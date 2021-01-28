#lang racket
(require 2htdp/image)

(define (dot s)
  (lambda (a)
    (underlay
     (circle (/ s 4) 'solid 'gray)
     (square s (truncate a) 'black))))

(define (sq2x2 i)
  (lambda (s)
    (lambda (a)
      (let ((ii (i (/ s 2))))
        (above (beside (ii        a)  (ii (* 0.9 a)))
               (beside (ii (* 0.7 a)) (ii (* 0.8 a))))))))

(define (step i)
  (lambda (s)
    (lambda (a)
      (let* ([i2 (sq2x2 i)]
             [i4 (sq2x2 i2)]
             [i8 (sq2x2 i4)])
        (above (beside ((i  s) a) ((i2 s) a))
               (beside ((i8 s) a) ((i4 s) a)))))))

(provide main)
(define (main . args)
  (save-image
   (((step (step dot)) 200) 255)
   (car args)))
