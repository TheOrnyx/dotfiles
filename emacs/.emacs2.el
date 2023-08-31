;;TODO
;;
;; make thing look better and disable scroll bar etc
;; git
;; set keybinds https://github.com/nixin72/k-nav.el
;; maybe check out hydra
;; maybe check out MEOW
;; Poss fix minibuffer height if that becomes a problem
;; possibly switch to init.el
;; probably reorganize
;; maybe install persp mode
;; make some better comments
;; possibly configure some of the autocomplete kinda stuff - kinda done but can probs be fixed, delay is kidna fucked sometimes
;; remove some of the commented out chunks that aren't and won't be needed
;; convert this to init.el poss and git that shit
;; convert some of the regular require package to use-package
;; set up workspace stuff
;; probably sort the packages and stuff into config, packages etc
;; check out pulsar - maybe a replacement for beacon
;; check out ace popup menu
;; probably fix my stupid ocitcon thing
;; Maybe fix some of the free variable errors etc lmao
;; probably make my own theme tbh, this one's nice but customize yass
;; check out HELM
;; probably tweak my comments to use proper conventions
;; ADD THE SNIPPET FOLDER TO THE GITHUB!!!!
;; Probably add some stuff for markdown and org mode
;; also learn org mode dickhead
;; ELECTRIC MODE PARENTHESIS BLAHHHH

;;Probably check out tabbar mode

;;;; NOTES ABOUT THE COMMENT CONVENTIONS
;-----------------------------------------------
; ;Single semicolons (;) should be used (format "message" format-args)or inline comments.
; ;Double semicolons (;;) should be used for line comments.
; ;Triple semicolons (;;;) should be used for "comments that should be considered a heading by Outline minor mode"
; ;Quadruple semicolons (;;;;) should be used for headings of major sections of a program.
;----------------------------------------------



;;;Treesitter
(setq treesit-language-source-alist
      '((bash "https://github.com/tree-sitter/tree-sitter-bash")
	(java "https://github.com/tree-sitter/tree-sitter-java")
	(commonlisp "https://github.com/theHamsta/tree-sitter-commonlisp")
	(clojure "https://github.com/sogaiu/tree-sitter-clojure")
	(cpp "https://github.com/tree-sitter/tree-sitter-cpp")
	(glsl "https://github.com/theHamsta/tree-sitter-glsl")
	(haskell "https://github.com/tree-sitter/tree-sitter-haskell")
	(ruby "https://github.com/tree-sitter/tree-sitter-ruby")
	(cmake "https://github.com/uyha/tree-sitter-cmake")
	(css "https://github.com/tree-sitter/tree-sitter-css")
	(elisp "https://github.com/Wilfred/tree-sitter-elisp")
	(go "https://github.com/tree-sitter/tree-sitter-go")
	(html "https://github.com/tree-sitter/tree-sitter-html")
	(javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
	(json "https://github.com/tree-sitter/tree-sitter-json")
	(make "https://github.com/alemuller/tree-sitter-make")
	(markdown "https://github.com/ikatyang/tree-sitter-markdown")
	(python "https://github.com/tree-sitter/tree-sitter-python")
	(toml "https://github.com/tree-sitter/tree-sitter-toml")
	(tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
	(typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Controllers for different sections ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *eglot-enabled* t) ;using eglot
(defvar *lsp-mode-enabled* nil) ;using lsp-mode
(defvar *using-ivy* t) ;using ivy
(defvar *using-company* nil)
(defvar *using-corfu* t)

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;
;; Package Setup ;;
;;;;;;;;;;;;;;;;;;;

;Setup melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;use package stuff
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))

;; ;Straight
;; (defvar bootstrap-version)
;; (let ((bootstrap-file
;;        (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;;       (bootstrap-version 6))
;;   (unless (file-exists-p bootstrap-file)
;;     (with-current-buffer
;;         (url-retrieve-synchronously
;;          "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;;          'silent 'inhibit-cookies)
;;       (goto-char (point-max))
;;       (eval-print-last-sexp)))
;;   (load bootstrap-file nil 'nomessage))
;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Code And Configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq confirm-kill-emacs #'yes-or-no-p) ;;Confirm exist
(setq shell-file-name "/bin/sh") ;; Fixes ripgrep issues
(setq epg-gpg-program "gpg2")
(setq auth-sources '("~/.authinfo.gpg")) ;; Sets authinfo file to gpg one

(setq save-interprogram-paste-before-kill t)
(setq pixel-scroll-precision-large-scroll-height 40.0)

(defun kill-buffer-path ()
  "Copy the current buffer path."
  (interactive)
  (kill-new (buffer-file-name)))

(set-frame-parameter nil 'alpha-background 95)
(set-frame-parameter nil 'cursor-color "coral")
(setq display-battery-mode 1)
(setq calendar-week-start-day 1)
(display-time-mode 1)
(display-battery-mode 1)

(setq zone-when-idle 120)
(add-to-list 'load-path "~/.emacs.d/extra/")
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "C-M-z") 'zap-to-char)
(global-set-key (kbd "M-Z") 'zap-to-char)

(setq next-line-add-newlines t)
(setq gc-cons-threshold 1600000)
(global-set-key (kbd "M-i") 'imenu)				;;Binding for imenu
(setq inferior-lisp-program "sbcl")				;;set the common lisp to SBCL
(tool-bar-mode -1)						;; remove the tool bar
(setq undo-limit 240000)					;; Change the undo limit to 240000 bytes - might need tweaking

(setq org-support-shift-select t)
(setq org-image-actual-width 400)
(setq gc-cons-threshold 50000000)
(add-to-list 'initial-frame-alist '(fullscreen . maximized))    ;; Maximize on startup
;(setq read-process-output-max (* 1024 1024)) ;; reenable if problems
;(setq gc-cons-threshold 1600000)

(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Misc Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Git Gutter Stuff
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

;;Beacon Mode
(use-package beacon
  :config
  (beacon-mode 1)
  (setq beacon-size 40)
  (setq beacon-blink-duration 1))

(use-package format-all)

(use-package ialign
  :config
  (global-set-key (kbd "C-c l") #'ialign))

(use-package sr-speedbar
  :config
  (setq sr-speedbar-right-side nil)
  (global-set-key (kbd "C-c t") 'sr-speedbar-toggle))

(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
	      ("C-c p" . projectile-command-map)))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.1))

(use-package all-the-icons
  :if (display-graphic-p))

(use-package devdocs
  :config (global-set-key (kbd "C-h z") 'devdocs-lookup))

(use-package quickrun
  :bind ("C-c r" . quickrun))

(use-package iedit)

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package yasnippet
  :config (yas-global-mode 1))
(use-package yasnippet-snippets
  :after (yasnippet))

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(when *using-corfu*
  (use-package corfu
    :init
    (global-corfu-mode)
    :config
    (setq corfu-sources
	  '(corfu-source-company-capf))))



;---------------------------------------------------------
;;;;;;;;;;;;;;;
;; IVY stuff ;;
;;;;;;;;;;;;;;;

(when *using-ivy*
  (use-package ivy
    :config
    (ivy-mode 1)
    (setq ivy-re-builders-alist '((t . ivy--regex-fuzzy)))
    (setq ivy-height 20)) ;probs tweak a bit

  (use-package ivy-rich
    :after (ivy counsel)
    :init
    (ivy-rich-mode 1))

  (use-package all-the-icons-ivy
    :init (add-hook 'after-init-hook 'all-the-icons-ivy-setup))

  (use-package counsel
    :after (ivy)
    :config
    (counsel-mode 1))

  (use-package ivy-prescient
    :after (prescient ivy counsel)
    :config
    (setq ivy-prescient-sort-commands
          '(:not swiper
		 counsel-grep
		 counsel-rg
		 counsel-projectile-rg
		 ivy-switch-buffer
		 counsel-switch-buffer))
    (setq ivy-prescient-retain-classic-highlighting t)
    (ivy-prescient-mode +1))

  (use-package company-prescient
    :after (prescient company)
    :config
    (company-prescient-mode +1)))



