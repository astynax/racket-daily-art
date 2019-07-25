#lang racket
(require 2htdp/image)

(define (block c1 c2 c3 s)
  (overlay
   (let* [[d (overlay (circle (* 1/12 s) 'solid c2)
                      (circle (* 1/6 s) 'solid c1))]
          [e (square (* 1/3 s) 0 'black)]
          [dsd (beside d e d)]
          [scs (beside e (circle (* 1/6 s) 'solid c3) e)]]
     (above dsd scs dsd))
   (square (* 2/3 s) 'solid c2)
   (square s 'solid c1)))

(define (step c0 c1 c2 c3 s)
 (let* [[sb (* 4/5 s)]
        [ss (* 1/5 s)]
        [bb (block c1 c0 c2 ss)]
        [by (block c2 c0 c3 ss)]]
   (above
    (beside (if (> sb 50)
                (overlay
                 (square sb 32 c0)
                 (rotate 180 (step c0 c3 c1 c2 sb)))
                (square sb 'solid c0))
            (above by bb by bb))
    (beside by bb by bb by))))

(save-image
 (step 'black 'red 'yellow 'orange 600)
 "output.png")