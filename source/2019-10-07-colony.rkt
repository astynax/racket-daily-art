#lang racket
(require 2htdp/image)

(define (step i f1 f2 s)
  (if (< s 50) (i f1 f2 s)
      (let* ([s1            (i           f1      f2  (/ s 6))]
             [s2            (i      (not f1)     f2  (/ s 6))]
             [li            (step i (not f1)     f2  (/ s 3))]
             [ri (rotate 90 (step i      f1 (not f2) (/ s 3)))]
             [pair (beside s1 s2)]
             [col (above pair ri li pair)])
        (beside col
                (above li pair pair ri)
                col))))

(define (item f1 f2 s)
  (overlay (circle (/ s 4) (if (xor f1 f2) 0 128) 'Yellow)
           (circle (/ s 2) 'solid (if (or f1 f2) 'DarkSeaGreen 'SeaGreen))
           (square s 0 'White)))

(save-image
 (overlay
  (step item #t #f 600)
  (square 600 'solid 'DarkGreen))
 "output.png")
