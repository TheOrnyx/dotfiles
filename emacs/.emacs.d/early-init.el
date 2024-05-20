;;; early-init.el --- early init

;;; Commentary:
;; My early init file
;; Used for like GUI setup and stuff

;;;Code:
;; Boot timer (from https://systemcrafters.net/emacs-from-scratch/cut-start-up-time-in-half/)
(setq initial-scratch-message
      ";; Welcome to the Emacs enjoy your stay\n;; You know the drill, open some files, write some stuff and be kind <3\n
;;                       /^--^\\     /^--^\\     /^--^\\
;;                       \\____/     \\____/     \\____/
;;                      /      \\   /      \\   /      \\
;;                     |        | |        | |        |
;;                      \\__  __/   \\__  __/   \\__  __/
;; |^|^|^|^|^|^|^|^|^|^|^|^\\ \\^|^|^|^/ /^|^|^|^|^\\ \\^|^|^|^|^|^|^|^|^|^|^|^|
;; | | | | | | | | | | | | |\\ \\| | |/ /| | | | | | \\ \\ | | | | | | | | | | |
;; | | | | | | | | | | | | / / | | |\\ \\| | | | | |/ /| | | | | | | | | | | |
;; | | | | | | | | | | | | \\/| | | | \\/| | | | | |\\/ | | | | | | | | | | | |
;; #########################################################################
;; | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |
;; | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | | |\n\n")
(defun efs/display-startup-time ()
  "Boot timer"
  (let ((startup-time (float-time (time-subtract after-init-time before-init-time)))
        (gc-collections gcs-done))
    (setq initial-scratch-message
          (format "%s;; Emacs loaded in %.2f seconds with %d garbage collections.\n\n"
                  initial-scratch-message
                  startup-time
                  gc-collections))))

(add-hook 'after-init-hook #'efs/display-startup-time)

;; Transparency stuff
(add-to-list 'initial-frame-alist '(fullscreen . maximized))    ;; Maximize on startup
(setq initial-frame-alist default-frame-alist)
(set-frame-parameter nil 'alpha-background 99)
(add-to-list 'default-frame-alist '(alpha-background . 99))
(tool-bar-mode -1) ;; remove the tool bar

;; Package setup
					;Setup melpa
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives '("nongnu" . "https://elpa.nongnu.org/nongnu/"))

(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
(require 'use-package)
(provide 'early-init)

;;; early-init.el ends here
