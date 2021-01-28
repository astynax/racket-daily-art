#lang racket
(require 2htdp/image)

; partial application: (($ + 1 2) 3 4) => 10
(define ($ f . args)
  (lambda (a . args2)
    (apply f (append args (cons a args2)))))

(define (sq i f s)
  (let ([i1 (i      f  s)]
        [i2 (i (not f) s)])
    (above (beside i1 i2)
           (beside i2 i1))))

(define (piece f s)
  ((if f
       flip-horizontal
       ($ overlay
          (circle (/ s 8) 'solid 'black)
          (circle (/ s 4) 'solid 'gray)))
   (line s s (make-pen 'gray (/ s 10) 'solid 'round 'round))))

(provide main)
(define (main . args)
  (save-image
   (let [(i (sq ($ sq ($ sq ($ sq piece))) #f 40))]
     (overlay
      i
      (rectangle (image-width i) (image-height i) 'solid 'darkgreen)))
   (car args)))
