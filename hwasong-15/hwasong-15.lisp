(ql:quickload :cl-proj)
(ql:quickload :iterate)

(defpackage :hwasong-15
  (:use :iter :common-lisp)
)

(in-package :hwasong-15)

(defun make-circle ()
  (with-open-file (out "range.json" :direction :output :if-exists :supersede)
    (pj:missile-range 39.03 125.75
		      (* 4700 1000)
		      :out out :mode :split)))

(make-circle)
