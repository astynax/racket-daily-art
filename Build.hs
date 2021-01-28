module Main where

import Data.Foldable
import Data.List
import qualified Data.Text as T
import Development.Shake hiding ((~>))
import Development.Shake.FilePath
import Development.Shake.Forward
import Text.Mustache


main :: IO ()
main = do
  let
    target      = "docs"

    sourcesLst  = target </> "sources.lst"
    pygmentsCss = target </> "pygments.css"
    indexHtml   = target </> "index.html"

    pygmentsVersion   = target </> "pygments.version"
    racketVersion     = target </> "racket.version"
    imagemagicVersion = target </> "imagemagic.version"

    fwdOpts = (forwardOptions shakeOptions){shakeLintInside = [target]}
    opts    = shakeOptions{shakeFiles = target}

  tIndex <- loadTemplate $ "template" </> "index.html"
  tPage  <- loadTemplate $ "template" </> "page.html"

  shakeForward fwdOpts $ do
    sources <- getDirectoryFiles "source" ["*.rkt"]
    writeFileChanged sourcesLst $
      unlines $ reverse $ sort sources

  sources <- lines <$> readFile sourcesLst

  shakeArgs opts $ do
    let
      targets ext = [target </> f -<.> ext | f <- sources]
      htmls       = targets "html"
      outputs     = targets "png"
      thumbnails  = targets "thumbnail.png"

    want $
      [ pygmentsCss
      , indexHtml ]
      <> htmls
      <> outputs
      <> thumbnails

    pygmentsVersion   %> toolVersion "pygmentize -V"
    racketVersion     %> toolVersion "racket --version"
    imagemagicVersion %> toolVersion "convert --version"

    phony "clean" $ do
      putNormal "Cleaning up.."
      removeFilesAfter target ["//*"]

    pygmentsCss %> \out -> do
      need [pygmentsVersion]
      Stdout css <- cmd "pygmentize" "-f" "html" "-S" "colorful"
      writeFile' out css

    indexHtml %> \out -> do
      need
        [ "template" </> "index.html"
        , sourcesLst ]
      writeHtml out tIndex $ object
        [ T.pack "pages" ~>
          [ object
            [ T.pack "file"      ~> (rkt -<.> "html")
            , T.pack "thumbnail" ~> (rkt -<.> "thumbnail.png")
            , T.pack "name"      ~> rkt ]
          | rkt <- sources ] ]

    for_ sources $ \src -> do
      let racketFile = "source" </> src

      target </> src -<.> "html" %> \out -> do
        need
          [ pygmentsVersion
          , "template" </> "page.html"
          , racketFile ]
        Stdout contents <-
          cmd "pygmentize" "-l" "racket" "-f" "html"
            "-O" "style=colorful,linenos=1" racketFile
        writeHtml out tPage $ object
          [ T.pack "name" ~> src
          , T.pack "code" ~> T.pack contents
          , T.pack "img"  ~> (src -<.> "png") ]

      target </> src -<.> "png" %> \out -> do
        need
          [ racketVersion
          , racketFile ]
        cmd_ "racket" "-t" racketFile "-m" "--" out

      target </> src -<.> "thumbnail.png" %> \out -> do
        let input = target </> src -<.> "png"
        need
          [ imagemagicVersion
          , input ]
        cmd_ "convert" input "-resize" "100x100" out

  where
    toolVersion c out = do
      alwaysRerun
      Stdout stdout <- cmd c
      writeFileChanged out stdout

    writeHtml out tpl = writeFile' out . T.unpack . substitute tpl

    loadTemplate fn =
      either (error . show) id <$> localAutomaticCompile fn
