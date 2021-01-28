#lang racket
(require 2htdp/image)

(define (->color x) (if x 'OldLace 'Sienna))
(define (next-color x) (not x))

(define (step i c s)
  (let ([i1 (i c s)])
    (if (< s 30) i1
      (let ([i2 (flip-vertical
                 (step i (next-color c) (/ s 2)))])
        (overlay/align
         'left 'bottom i2
         (overlay/align
          'right 'top i2
          i1))))))

(define (item c s)
  (let* ([fg (->color c)]
         [bg (->color (next-color c))]
         [q (/ s 8)]
         [c0 (circle (* 2 q)    192 fg)]
         [c1 (circle      q      64 fg)]
         [c2 (circle (* 2 q) 'solid bg)]
         [c3 (circle (* 3 q) 'solid fg)])
    (overlay
     c1 c2 c3
     (place-image
      c0 0 0
      (place-image
       c0 s s
       (square s 'solid bg))))))

(provide main)
(define (main . args)
  (save-image
   (step item #f 800)
   (car args)))
