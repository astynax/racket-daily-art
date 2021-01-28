#lang racket
(require 2htdp/image)
(require racket/set)

(define all9 (list->set (range 9)))

(define (->color x)
  (case x
    [(4) 'DarkSlateBlue]
    [(3) 'SteelBlue]
    [(2) 'DarkTurquoise]
    [(1) 'Cyan]
    [else 'Yellow]))

(define (step v c s)
  (if (or (set-empty? v) (< s 10))
      (circle s 'solid (->color c))
      (let* ([s3 (/ s 3)]
             [item (lambda (x)
                     (if (set-member? v x)
                         (step (set-remove v x) (+ c 1) s3)
                         (step (set) c s3)))])
        (above (beside (item 8) (item 7) (item 6))
               (beside (item 5) (item 4) (item 3))
               (beside (item 2) (item 1) (item 0))))))

(provide main)
(define (main . args)
  (save-image
   (overlay
    (step all9 0 400)
    (square 800 'solid 'black))
   (car args)))
