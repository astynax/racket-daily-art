#lang racket
(require 2htdp/image)

(define (item s f)
  (let ([corner (underlay
                 (circle (* 0.6 s) 'solid 'GreenYellow)
                 (circle (* 0.4 s) 'solid (if f 'ForestGreen 'Black)))])
    (place-image
     corner s s
     (place-image
      (rotate 180 corner) 0 0
      (square s 'solid (if f 'Black 'ForestGreen))))))

(define (block s)
  (let* ([i (λ (f) (item s f))]
         [r (λ (f) (flip-horizontal (i f)))])
    (overlay
     (circle (* 0.2 s) 'solid 'yellow)
     (above (beside (i #t) (r #t))
            (beside (r #t) (r #f))))))

(define (step i f s)
  (if (< s 80)
      (rotate (if f 0 180) (i s))
      (let ([ii (λ (x) (step i (not x) (/ s 2)))])
        (above (beside (rotate (if f   0 -90) (ii (not f)))
                       (rotate (if f   0 180) (ii      f)))
               (beside (rotate (if f  90   0) (ii (not f)))
                       (rotate (if f -90   0) (ii      f)))))))

(provide main)
(define (main . args)
  (save-image
   (step block #t 400)
   (car args)))
