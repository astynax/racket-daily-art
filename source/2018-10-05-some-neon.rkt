#lang racket
(require 2htdp/image)

(define ($ f . args)
  (lambda (a . args2)
    (apply f (append args (cons a args2)))))

(define (choose l) (list-ref l (random 0 (length l))))

(define (bit s)
  (let* ([color (choose (list 'Cyan  'HotPink 'MediumSpringGreen))]
         [style (choose (list 'solid 'dot     'long-dash))]
         [shape (choose (list ($ circle (/ (- s 6) 2))
                              ($ square (- s 6))
                              ($ rhombus (* 0.707 (- s 6)) 90)))])
    (overlay (shape 'outline (make-pen color 3 style 'round 'round))
             (square s 'solid 'black))))

(define (item s)
  (if (<= s 20) (bit s)
      (case (random 0 7)
        [(0 1) (bit s)]
        [(2) (square s 'solid 'black)]
        [else (above (beside (item (/ s 2)) (item (/ s 2)))
                     (beside (item (/ s 2)) (item (/ s 2))))])))

(provide main)
(define (main . args)
  (random-seed 96)
  (save-image
   (item 640)
   (car args)))
