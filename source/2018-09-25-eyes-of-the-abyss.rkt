#lang racket
(require 2htdp/image)

; partial application: (($ + 1 2) 3 4) => 10
(define ($ f . args)
  (lambda (a . args2)
    (apply f (append args (cons a args2)))))

; basic item: () or <>
(define (item s f)
  (let* ([hs (/ s 2)]
         [inner (if f ($ circle (/ s 4) 'solid)
                    ($ rhombus (* 0.7 s) 90 'solid))]
         [color (if f 'GreenYellow 'SlateGray)])
    (beside (place-image (inner 'black)
                         hs hs
                         (rectangle hs s 'solid 'LightSteelBlue))
            (place-image (inner color)
                         0 hs
                         (rectangle hs s 'solid 'black)))))

; rotating combinator
(define (four-rotate i f)
  (let ([i1 (rotate (if f -90 90) (i f))]
        [i2 (rotate (if f 180 0)  (i (not f)))]
        [i3 (rotate (if f 90 -90) (i f))]
        [i4 (rotate (if f 0 180)  (i (not f)))])
    (above (beside i1 i2)
           (beside i4 i3))))

; flipping combinator
(define (four-flip i f)
  (let ([i1 ((if f identity flip-horizontal) (i f))]
        [i2 ((if f flip-horizontal identity) (i f))])
    (above (beside i1 i2)
           (beside i2 i1))))

(save-image
 (four-flip ($ four-rotate ($ four-rotate ($ item 70))) #f)
 "output.png")
