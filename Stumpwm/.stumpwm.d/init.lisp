#|-*- mode:lisp -*-|#

;;;;;;;;;;;;
;; TODO's ;;
;;;;;;;;;;;;
; TODO - convert to org mode file
; TODO - maybe try and make an exception for firefox with the new tab, or learn a new bind

(in-package :stumpwm) ; Avoid constant use of :stumpwm

;; Constants for things like color (based off dracula colors)
(defparameter *color-background*	"#282A36")
(defparameter *color-selection*		"#44475A")
(defparameter *color-foreground*	"#F8F8F2")
(defparameter *color-comment*		"#6272a4")
(defparameter *color-cyan*		"#8be9fd")
(defparameter *color-green*		"#50fa7b")
(defparameter *color-orange*		"#ffb86c")
(defparameter *color-pink*		"#ff79c6")
(defparameter *color-purple*		"#bd93f9")
(defparameter *color-red*		"#ff5555")
(defparameter *color-yellow*		"#f1fa8c")


;; hopefully fix the path
;; (stumpwm:add-to-load-path "$HOME/.stumpwm.d/volume")
;; (stumpwm:add-to-load-path "$HOME/.stumpwm.d/contrib")
(init-load-path *module-dir*)

;; Extra libraries to use
(stumpwm:load-module "cpu")
(stumpwm:load-module "swm-gaps")
(stumpwm:load-module "volume")
(ql:quickload "cl-diskspace") ; needed for disk
(ql:quickload "cl-mount-info"); needed for disk
(stumpwm:load-module "disk")
(stumpwm:load-module "wifi")
(stumpwm:load-module "battery-portable")
(stumpwm:load-module "shell-command-history")
(stumpwm:load-module "command-history")
(ql:quickload "slynk") ; needed for emacs connect

;; Set font to cozette
(set-font "-misc-tamzenforpowerline-medium-*-*-*-15-120-*-*-*-*-*-*")

;; Colors and general appearance stuff!!
; All the color
(setq *colors*
      `(,*color-background*	;; 0 black
	,*color-red*		;; 1 red
	,*color-green*		;; 2 green
	,*color-yellow*		;; 3 yellow
	,*color-purple*		;; 4 blue
	,*color-pink*		;; 5 magenta
	,*color-cyan*		;; 6 cyan
	,*color-foreground*))	;; 7 white

; Message and input window stuff
(setf stumpwm:*input-window-gravity*     :top-right
      stumpwm:*message-window-padding*   10
      stumpwm:*message-window-y-padding* 10
      stumpwm:*message-window-gravity*   :top-right)

; Gaps!!!
(setf ;; swm-gaps:*head-gaps-size*  0
      swm-gaps:*outer-gaps-size* 4)

; Border Stuff
(stumpwm:set-unfocus-color "#dddddd")
(stumpwm:set-focus-color   "#007acc")
(setf stumpwm:*normal-border-width* 2)
(setf stumpwm:*maxsize-border-width* 1)
(setf stumpwm:*window-border-style* 'THIN)
(stumpwm:set-float-unfocus-color *color-selection*)
(stumpwm:set-float-focus-color   *color-comment*)
(setf stumpwm::*transient-border-width* 1)

; General colors
(stumpwm:set-fg-color *color-foreground*)
(stumpwm:set-bg-color *color-background*)


;; Configure and enable the modeline
; Modeline colors
(setf stumpwm:*mode-line-background-color* *color-background*)
(setf stumpwm:*mode-line-foreground-color* *color-foreground*)
(setf *mode-line-highlight-template* "^74^R~A^*^r") ;; The format for the highlighted stuff on the modeline

; Format stuff
(setf disk::*disk-modeline-fmt* "%m: %p")
(setf cpu::*cpu-modeline-fmt* "%c %t")
(setf *window-format* "<%n%s%m%30t>")

(setf *screen-mode-line-format*
      (list "[%g] "			; List all groups
            "%v"                        ; Windows
            "^>"                        ; Push right
	    " | %V"			; Volume
	    " | %I"			; Wific
	    " | %D"			; Disk
            " | %C"                     ; CPU module
	    " | %B" 			; Battery
            " | %d")			; Clock
      )

(setf *mode-line-timeout* 1) ;; Make it update more frequently
			     ;;(NOTE - every second may be to much, maybe decrese?)

(stumpwm:enable-mode-line (stumpwm:current-screen)
			  (stumpwm:current-head) t)

;; Launch the copyq server
(stumpwm:run-shell-command "copyq")

;; Basic behaviour stuff
(setf *mouse-focus-policy* :click) ;; Make it so I can hover mouse to change stuff
(setf *input-history-ignore-duplicates* t) ;; Avoid repeats in history

;; functions for floating and toggle always on top to prevent glitchiness
(defcommand float-raise-this () ()
  (float-this)
  (toggle-always-on-top))

(defcommand unfloat-raise-this () ()
  (unfloat-this)
  (toggle-always-on-top))

;; Use alacritty instead of xterm
(define-key *root-map* (kbd "c") "exec alacritty")
(define-key *root-map* (kbd "C-c") "exec alacritty")

;; Normal top level keybinds 
(define-key *top-map* (kbd "SunPrint_Screen") "exec flameshot gui") ;; Flameshot printscreen
(define-key *top-map* (kbd "s-v") "exec copyq toggle") ;; copyq
(define-key *root-map* (kbd "l") "exec betterlockscreen -l") ;; lock screen

(define-key *top-map* (kbd "XF86MonBrightnessUp") "exec lux -a 10%") ;; Increase brightness
(define-key *top-map* (kbd "XF86MonBrightnessDown") "exec lux -s 10%") ;; Decrease brightness

(define-key *top-map* (kbd "XF86AudioRaiseVolume") "exec amixer set Master 5%+") ;; Increase volume
(define-key *top-map* (kbd "XF86AudioLowerVolume") "exec amixer set Master 5%-") ;; Increase volume
(define-key *top-map* (kbd "XF86AudioMute") "exec amixer set Master toggle") ;; Toggle mute

;; Send raw key and a raw C-t key bind so I can use new tab easily (kinda gross)
(define-key *root-map* (kbd "C-q") "send-raw-key")
(define-key *top-map* (kbd "s-t") "send-escape")

;; Keys to float things
(define-key *root-map* (kbd "f") "float-raise-this")
(define-key *root-map* (kbd "C-f") "unfloat-raise-this")

;; Make all my preferred workspaces
(setf stumpwm:*group-format* "%t")
(stumpwm:gnewbg "Editor")
(stumpwm:gnewbg "Discord")
(stumpwm:gnewbg "4")
(stumpwm:gnewbg "5")
(stumpwm:gnewbg "6")
(stumpwm:gnewbg "7")
(stumpwm:gnewbg "8")
(stumpwm:gnewbg "9")

;; Command to start a new sly session to connect through emacs
;; https://www.reddit.com/r/stumpwm/comments/ouuh1c/comment/h75gwr0/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
(defcommand slynk (port) ((:string "Port number: "))
  (sb-thread:make-thread
   (lambda ()
     (slynk:create-server :port (parse-integer port) :dont-close t))
   :name "slynk-manual"))

;; Initializing stuff
(when stumpwm:*initializing*
  ;; (swm-gaps:toggle-gaps)
  (update-color-map (current-screen))
  (init-load-path *module-dir*)
  (stumpwm:which-key-mode))
