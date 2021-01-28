#lang racket
(require 2htdp/image)

(define (->color c)
  (cond [(= c 0) 'indigo]
        [(= c 1) 'palevioletred]
        [(= c 2) 'moccasin]
        [(= c 3) 'lemonchiffon]
        [else 'white]))

(define (next-c c) (modulo (+ 1 c) 5))

(define (i c s)
  (if (< s 5)
      (square s 'solid (->color c))
      (overlay (rotate 45 (i (next-c c) (* 0.707 s)))
               (square s 'solid (->color c)))))

(define (sq2x2 i1 i2)
  (above (beside i1 i2)
         (beside i2 i1)))

(define (step c s)
  (if (< s 10) (i (next-c c) (* 1.2 s))
      (sq2x2 (step (next-c c) (/ s 2)) (i c (* 0.707 s)))))

(provide main)
(define (main . args)
  (save-image
   (step 0 800)
   (car args)))
