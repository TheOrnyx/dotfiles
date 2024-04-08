;;;; volume.lisp

(in-package #:volume)

;; Install the formatter (using V, hopefully it's not taken)
(add-screen-mode-line-formatter #\V 'volume-modeline)

(defun fmt-volume-wireplumber-master ()
  "Formatter for master volume using wireplumber"
  (let* ((command (uiop:run-program "wpctl get-volume @DEFAULT_AUDIO_SINK@" :output :string))
	 (muted   (search "[muted]" command :test #'char-equal))
	 (vol     (cl-ppcre:all-matches-as-strings "\\d+(\\.+)?(\\d*)?" command)))
    (if (and muted *volume-muted-value*)
	*volume-muted-value*
	vol)))

(defun fmt-volume-master ()
  "formatter for master volume"
  (funcall *volume-master-function*)
  )

;; customizable variables
(defvar *volume-muted-value* "muted"
  "The value to display when the audio device is muted.
If nil then print the audio percentage")
(defvar *volume-master-function* #'fmt-volume-wireplumber-master
  "The function to call when using fmt-volume-wireplumber-master
Implemented as a seperate function so people can implement commands for their own audio provider easily")

(defun volume-modeline (ml)
  (declare (ignore ml))
  (format-expand *volume-formatters-alist*
		 *volume-modeline-fmt*))

(defvar *volume-formatters-alist*
  '((#\m fmt-volume-master)))

(defvar *volume-modeline-fmt* "Vol: %m"
  "The default value for displaying volume information on the modeline.

@table @asis
@item %%
A literal '%'
@item %m
Master volume
@item %l
left ear volume
@item %r
right ear volume
@end table
")
