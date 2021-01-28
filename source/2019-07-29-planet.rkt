#lang racket
(require 2htdp/image)
(require lang/posn)

(define (tree s c)
  (scale
   (/ s 225)
   (let [[trunk (polygon
                 (list
                  (make-posn 70 200)
                  (make-posn 80 130) (make-posn 20 70) (make-posn 85 100)
                  (make-posn 110 60) (make-posn 90 0)
                  (make-posn 125 40) (make-posn 160 20) (make-posn 130 60)
                  (make-posn 125 80) (make-posn 155 80) (make-posn 120 95)
                  (make-posn 115 120)
                  (make-posn 130 200))
                 'solid
                 'brown)]
         [leafs1 (circle 50 'solid c)]
         [leafs2 (circle 40 'solid c)]
         [leafs3 (circle 30 'solid c)]
         [leafs4 (circle 20 'solid c)]]
     (overlay/offset
      (overlay/offset
       (overlay/offset
        (overlay/offset
         trunk
         -40 -10
         leafs1)
        20 -85
        leafs2)
       70 -60
       leafs3)
      60 -5
      leafs4))))

(define (cloud s c)
  (scale
   (/ s 255)
   (overlay/offset
    (overlay/offset
     (circle 50 'solid c)
     70 -10
     (circle 70 'solid c))
    90 20
    (circle 40 'solid c))))

(define (pinned a r f i)
  (let [[w (image-width i)]
        [h (image-height i)]]
    (rotate
     a
     (put-pinhole
      (* 0.5 w) (+ r h)
      ((if f flip-horizontal identity)
       i)))))

(define (shade ww w)
  (let [[s (/ (- ww w w) 2)]]
    (beside
     (rectangle s ww 0 'black)
     (rectangle w ww 32 'black)
     (rectangle w ww 80 'black)
     (rectangle s ww 127 'black))))

(define (picture s)
  (scale
   (/ s 140)
   (clear-pinhole
    (place-image
     (overlay/pinhole
      (rotate
       45
       (above
        (star-polygon 7 31 8 'solid 'yellow)
        (square 160 0 'black)
        (circle 20 'solid 'ivory)))
      (rotate -45 (shade 200 10))
      (star-polygon 3 50 13 'solid 'darkorange)
      (pinned 35 20 #f (tree 40 'orange))
      (pinned -25 20 #t (tree 30 'yellow))
      (pinned -75 20 #f (tree 35 'red))
      (pinned 90 20 #t (tree 35 'red))
      (pinned 135 20 #t (tree 45 'orange))
      (pinned 190 20 #f (tree 40 'yellow))
      (pinned 230 20 #t (tree 25 'orange))
      (pinned 0 50 #f (cloud 25 'white))
      (pinned 60 50 #f (cloud 40 'white))
      (pinned 110 50 #f (cloud 20 'white))
      (pinned 170 50 #t (cloud 30 'black))
      (pinned -100 50 #f (cloud 35 'black))
      (pinned -140 50 #t (cloud 30 'black))
      (square 140 'solid 'skyblue))
     70 70
     (square 140 0 'black)))))

(provide main)
(define (main . args)
  (save-image
   (picture 800)
   (car args)))
