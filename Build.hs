module Main where

import Data.Foldable
import Data.List
import qualified Data.Text as T
import Development.Shake hiding ((~>))
import Development.Shake.FilePath
import Development.Shake.Forward
import Text.Mustache
import System.Directory

main :: IO ()
main = do
  tIndex <- loadTemplate $ "template" </> "index.html"
  tPage <- loadTemplate $ "template" </> "page.html"

  shakeForward fwdOpts $ do
    sources <- getDirectoryFiles "source" ["*.rkt"]
    writeFileChanged ("_build" </> "sources.txt") $
      unlines $ reverse $ sort sources

  sources <- lines <$> readFile ("_build" </> "sources.txt")

  shakeArgs opts $ do
    let
      targets ext = ["_build" </> f -<.> ext | f <- sources]
      htmls       = targets "html"
      outputs     = targets "png"
      thumbnails  = targets "thumbnail.png"

    want $
      [ "_build" </> "pygments.css"
      , "_build" </> "index.html"
      , "_build" </> "chunk.html" ]
      <> htmls
      <> outputs
      <> thumbnails

    "_build" </> "pygments.version" %> toolVersion "pygmentize -V"
    "_build" </> "racket.version" %> toolVersion "racket --version"
    "_build" </> "imagemagic.version" %> toolVersion "convert --version"

    phony "clean" $ do
      putNormal "Cleaning up.."
      removeFilesAfter "_build" ["//*"]

    "_build" </> "pygments.css" %> \out -> do
      need ["_build" </> "pygments.version"]
      Stdout css <- cmd "pygmentize" "-f" "html" "-S" "colorful"
      writeFile' out css

    "_build" </> "index.html" %> \out -> do
      need
        [ "template" </> "index.html"
        , "_build" </> "sources.txt" ]
      writeHtml out tIndex $ object
        [ T.pack "pages" ~>
          [ object
            [ T.pack "file"      ~> (rkt -<.> "html")
            , T.pack "thumbnail" ~> (rkt -<.> "thumbnail.png")
            , T.pack "name"      ~> rkt ]
          | rkt <- sources ] ]

    for_ sources $ \src -> do
      let racketFile = "source" </> src

      "_build" </> src -<.> "html" %> \out -> do
        need
          [ "_build" </> "pygments.version"
          , "template" </> "page.html"
          , racketFile ]
        Stdout contents <-
          cmd "pygmentize" "-l" "racket" "-f" "html"
            "-O" "style=colorful,linenos=1" racketFile
        writeHtml out tPage $ object
          [ T.pack "name" ~> src
          , T.pack "code" ~> T.pack contents
          , T.pack "img"  ~> (src -<.> "png") ]

      "_build" </> src -<.> "png" %> \out -> do
        need
          [ "_build" </> "racket.version"
          , racketFile ]
        cmd_ "racket" "-t" racketFile "-m" "--" out

      "_build" </> src -<.> "thumbnail.png" %> \out -> do
        let input = "_build" </> src -<.> "png"
        need
          [ "_build" </> "imagemagic.version"
          , input ]
        cmd_ "convert" input "-resize" "100x100" out

  where
    fwdOpts = (forwardOptions shakeOptions){shakeLintInside = ["_build"]}
    opts = shakeOptions{shakeFiles = "_build"}

    toolVersion c out = do
      alwaysRerun
      Stdout stdout <- cmd c
      writeFileChanged out stdout

    writeHtml out tpl = writeFile' out . T.unpack . substitute tpl

    loadTemplate fn =
      either (error . show) id <$> localAutomaticCompile fn
