#lang racket
(require 2htdp/image)

(define (item s)
  (let ([dot (circle (/ s 4) 'solid 'teal)])
    (overlay (beside (overlay dot (circle (/ s 2) 'solid 'gold))
                     (overlay dot (circle (/ s 2) 'solid 'white)))
             (rectangle (* 2 s) s 'solid 'teal))))

(define (step i s)
  (if (< s 20)
      (i s)
      (let ([ii (step i (/ s 2))])
        (overlay/align
         'left 'center
         (rotate 90 ii)
         (overlay/align
          'right 'center
          (rotate -90 ii)
          (i s))))))

(provide main)
(define (main . args)
  (save-image
   (let* ([i (step item 400)]
        [r (rotate 90 i)])
   (overlay i (beside r r)))
   (car args)))
