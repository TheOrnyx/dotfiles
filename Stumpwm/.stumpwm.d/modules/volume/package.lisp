;;;; package.lisp

(defpackage #:volume
  (:use #:cl :stumpwm #:cl-ppcre)
  (:export #:*volume-modeline-fmt*
	   #:*volume-master-function*
	   #:*volume-muted-value*
	   #:fmt-volume-wireplumber-maste))
