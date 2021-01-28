#lang racket
(require 2htdp/image)

(define (step i n s)
  (if (< s 20)
      (i n s)
      (let* ([s3 (/ s 3)]
             [ii (i n s3)]
             [si (step i (+ n 1) s3)]
             [bi (rotate 180 (step i (+ n 1) (* s3 2)))])
        (above (beside (above ii si) bi)
               (beside si ii si)))))

(define (item n s)
  (overlay
   (circle (/ s 20) (if (zero? (modulo n 2)) 200 0) 'Cyan)
   (circle (/ s 3) 'solid 'black)
   (square s (max 0 (- 220 (* n 20))) 'SkyBlue)))

(provide main)
(define (main . args)
  (save-image
   (overlay
    (step item 0 600)
    (square 600 'solid 'black))
   (car args)))
