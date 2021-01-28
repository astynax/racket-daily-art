#lang racket
(require 2htdp/image)

(define (dot flag s)
  (underlay (square s 'solid (if flag 'white 'black))
            (circle (/ s 2) 'solid 'gray)
            (circle (/ s 4) 'solid (if flag 'black 'white))))

(define (sq2x2 flag i1 i2)
  (if flag (sq2x2 #f i2 i1)
      (above (beside i1 i2)
             (beside i2 i1))))

(define (step flag s)
  (let ((i (dot flag s)))
    (if (< s 10)
        (underlay (square (* 2 s) 'solid (if flag 'white 'black)) i)
        (sq2x2 flag i (step (not flag) (/ s 2))))))

(provide main)
(define (main . args)
  (save-image
   (sq2x2 #t (step #t 160) (step #f 160))
   (car args)))
