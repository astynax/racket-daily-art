#lang racket
(require 2htdp/image)

(define (->color x)
  (list-ref '(Indigo
              BlueViolet
              Thistle
              LavenderBlush)
            (modulo x 4)))

(define (step i l f s)
  (if (< s 20)
      (i l s)
      (let* ([s2 (/ s 2)]
             [ii (step i (+ l 1) (not f) s2)]
             [ri (rotate 90 ii)]
             [li (if f (rotate 180 ii)
                     (square s2 0 'White))])
        (overlay (above (beside li ri)
                        (beside ri li))
                 (i l s)))))

(define (item l s)
  (overlay (circle (/ s 6) 120 'White)
           (square (/ s 2) 'outline 'Black)
           (square (/ s 2) 200 (->color l))
           (square s 0 'White)))

(provide main)
(define (main . args)
  (save-image
   (step item 0 #t 600)
   (car args)))
