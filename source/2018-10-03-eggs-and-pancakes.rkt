#lang racket
(require 2htdp/image)

(define (step i f s)
  (if (< s 40)
      (i f s)
      (let* ([s3 (/ s 4)]
             [si (i f s3)]
             [li (i (not f) (* 2 s3))]
             [ii (step i (not f) (* 2 s3))]
             [col (above si si)])
        (above (beside col li col)
               (beside (rotate -90 ii) (rotate 90 ii))))))

(define (item f s)
  (if f
      (overlay (square (* 0.25 s) 'solid 'LightYellow)
               (circle (* 0.5 s) 'solid 'Wheat)
               (square s 'solid 'Brown))
      (overlay (circle (* 0.125 s) 'solid 'Gold)
               (square (* 0.7 s) 'solid 'White)
               (circle (* 0.5 s) 'solid 'Black))))

(provide main)
(define (main . args)
  (save-image
   (overlay
    (step item #f 600)
    (square 600 'solid 'Chocolate))
   (car args)))
