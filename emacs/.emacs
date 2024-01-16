;;; .emacs --- My Emacs Config File



;; Author: Zaki Si-Lounis <cthulhu345@gmail.com>

;;TODO
;;
;; maybe check out hydra
;; possibly switch to init.el
;; maybe install persp mode
;; make some better comments
;; set up workspace stuff
;; probably make my own theme tbh, this one's nice but customize yass
;; probably tweak my comments to use proper conventions
;; ADD THE SNIPPET FOLDER TO THE GITHUB!!!!
;; Probably add some stuff for markdown and org mode
;; also learn org mode dickhead
;; ELECTRIC MODE PARENTHESIS BLAHHHH
;; Possibly install
;; install straight

;;;Code

;----------------------------------------------
;;;;;;;;;;;;;;;;;;;
;; Package Setup ;;
;;;;;;;;;;;;;;;;;;;

;Setup melpa
(require 'package)
(add-to-list 'package-archives '("gnu"   . "https://elpa.gnu.org/packages/"))
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))
(require 'use-package)
;---------------------------------------------------------

;;;;;;;;;;;;;;;;
;; Treesitter ;;
;;;;;;;;;;;;;;;;

;;Language grammars
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
	(gomod "https://github.com/camdencheek/tree-sitter-go-mod")
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

;; ;;Remap existing modes
;; (setq major-mode-remap-alist
;;       '((ruby-mode . ruby-ts-mode)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Controllers for different sections ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *using-eglot* t) ;using eglot
(defvar *lsp-mode-enabled* nil) ;using lsp-mode
(defvar *using-corfu* t)
(defvar *using-vertico* t)
(defvar *using-projectile* t)
(defvar *using-project.el* nil)

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme and UI stuff ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;Modeline
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :config
  (setq doom-modeline-support-imenu t)
  (setq doom-modeline-battery t))

(use-package dracula-theme)
;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Code And Configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq tab-width 4)
(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_NZ")

(setq image-use-external-converter 1)
(setq backup-directory-alist '(("." . "~/.backups/emacs/")))
(column-number-mode 1)

(defun my-pixel-scroll-hook ()
  "some stuff for pixel scrolling"
  (global-set-key [remap scroll-up-command] 'pixel-scroll-interpolate-down)
  (global-set-key [remap scroll-down-command] 'pixel-scroll-interpolate-up)
  (setq pixel-scroll-precision-large-scroll-height nil)
  (setq pixel-scroll-precision-momentum-tick 0.5)
  (setq pixel-scroll-precision-interpolate-page 1))

(add-hook 'pixel-scroll-mode-hook 'my-pixel-scroll-hook)
(pixel-scroll-mode 1)
(pixel-scroll-precision-mode 1)


;finish this later
;; (defun kill-remove-whitespace ()
;;   "kill item and remove trailing whitespace from it"
;;   (interactive)
  
;;   (let (killed-item (kill-line))
;;     )
;;   )

(defun open-terminal-here ()
  "Opens an alacritty session with the current directory set"
  (interactive)
  (call-process "alacritty" nil 0 nil "--working-directory" default-directory))

(defun open-nemo-here ()
  "Opens nemo aka my file manager at the current directory"
  (interactive)
  (call-process "nemo" nil 0 nil default-directory))

(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)

(recentf-mode 1)
(setq recentf-max-saved-items 100)
(run-at-time nil (* 5 60) 'recentf-save-list)
(global-set-key (kbd "C-x C-r") 'recentf)

(global-set-key (kbd "C-x C-b") 'ibuffer)
;(semantic-mode 1)
(global-set-key [remap dabbrev-expand] 'hippie-expand) ;Rebind to use hippie-expand
(winner-mode 1)
(setq confirm-kill-emacs #'yes-or-no-p) ;;Confirm exist
(setq shell-file-name "/bin/sh") ;; Fixes ripgrep issues

(require 'epa-file)
(epa-file-enable)
(setq epg-gpg-program "gpg2")
(setq auth-sources '("~/.authinfo.gpg")) ;; Sets authinfo file to gpg one

(setq save-interprogram-paste-before-kill t)


(defun kill-buffer-path ()
  "Copy the current buffer path."
  (interactive)
  (kill-new (buffer-file-name)))

(set-frame-parameter nil 'alpha-background 95)
(add-to-list 'default-frame-alist '(alpha-background . 95))
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
(setq initial-frame-alist default-frame-alist)
;(setq read-process-output-max (* 1024 1024)) ;; reenable if problems
;(setq gc-cons-threshold 1600000)

(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode Configs and Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq org-log-done t)

(use-package ox-moderncv
  :load-path "~/.emacs.d/extra/org-cv/"
  :init (require 'ox-moderncv))

(add-hook 'text-mode-hook #'flyspell-mode)
(use-package ox-hugo
  :after (ox))

;; forge ;;
(use-package forge
  :config
  (setq forge-alist '(("github.com" "api.github.com" "github.com" forge-github-repository)
		      ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository)
		      ("salsa.debian.org" "salsa.debian.org/api/v4" "salsa.debian.org" forge-gitlab-repository)
		      ("framagit.org" "framagit.org/api/v4" "framagit.org" forge-gitlab-repository)
		      ("gitlab.gnome.org" "gitlab.gnome.org/api/v4" "gitlab.gnome.org" forge-gitlab-repository)
		      ("codeberg.org" "codeberg.org/api/v1" "codeberg.org" forge-gitea-repository)
		      ("code.orgmode.org" "code.orgmode.org/api/v1" "code.orgmode.org" forge-gogs-repository)
		      ("bitbucket.org" "api.bitbucket.org/2.0" "bitbucket.org" forge-bitbucket-repository)
		      ("git.savannah.gnu.org" nil "git.savannah.gnu.org" forge-cgit**-repository)
		      ("git.kernel.org" nil "git.kernel.org" forge-cgit-repository)
		      ("repo.or.cz" nil "repo.or.cz" forge-repoorcz-repository)
		      ("git.suckless.org" nil "git.suckless.org" forge-stagit-repository)
		      ("git.sr.ht" nil "git.sr.ht" forge-srht-repository)
		      ("gitlab.ecs.vuw.ac.nz" "gitlab.ecs.vuw.ac.nz/api/v4" "gitlab.ecs.vuw.ac.nz" forge-gitlab-repository))))

(use-package smartparens
  :init (require 'smartparens-config)
  :config (add-hook 'prog-mode-hook #'smartparens-mode))

(use-package undo-tree
  :config (global-undo-tree-mode)
  (setq undo-tree-auto-save-history t)
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package org-view-mode)
(use-package org-modern
  :config
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))
(use-package org-download
  :config (add-hook 'dired-mode-hook 'org-download-enable)
  (setq-default org-download-image-dir "~/Pictures/foo"))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-setup))

;;Mail
(use-package notmuch)

(defun my-writing-hook ()
  "My hook for writing modes (mostly org mode)"
  (setq fill-column 80)
  (auto-fill-mode 1)
  )

(add-hook 'org-mode-hook 'my-writing-hook)

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;
;; Project Configs ;;
;;;;;;;;;;;;;;;;;;;;;

;; Projectile ;;
(when *using-projectile*
  (use-package projectile
    :init
    (projectile-mode +1)
    :bind (:map projectile-mode-map
		("C-c p" . projectile-command-map))
    :config
    (setq projectile-sort-order 'recentf)
    (setq projectile-indexing-method 'hybrid)
    (setq projectile-completion-system 'default)
    (setq projectile-mode-line-prefix " ")
    (projectile-mode +1)))


;; Project.el ;;
(when *using-project.el*)

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Misc Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;;TOML
(use-package toml-mode)

;;For working with R
(use-package ess)

;;Discord prescence
(use-package elcord
  :config
  (elcord-mode))

;; Git Gutter Stuff
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package color-identifiers-mode
  :config
  (add-to-list
   'color-identifiers:modes-alist
   `(java-ts-mode . ("" "\\_<\\([a-zA-Z_$]\\(?:\\s_\\|\\sw\\)*\\)"
                     (nil font-lock-variable-name-face))))
  (add-hook 'after-init-hook 'global-color-identifiers-mode))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

;;Beacon Mode
(use-package beacon
  :config
  ;(beacon-mode 1)
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

(use-package rainbow-mode)

(use-package iedit
  :config (global-set-key (kbd "C-:") 'iedit-mode))

(use-package flycheck
  :init
  (global-flycheck-mode))

(use-package dash)

(use-package yasnippet
  :config (yas-global-mode 1))

(use-package yasnippet-snippets
  :after (yasnippet))

;;Helpful
(use-package helpful
  :config
  ;; Note that the built-in `describe-function' includes both functions
  ;; and macros. `helpful-function' is functions only, so we provide
  ;; `helpful-callable' as a drop-in replacement.
  (global-set-key (kbd "C-h f") #'helpful-callable)
  (global-set-key (kbd "C-h v") #'helpful-variable)
  (global-set-key (kbd "C-h k") #'helpful-key)
  (global-set-key (kbd "C-h x") #'helpful-command)
  ;; Lookup the current symbol at point. C-c C-d is a common keybinding
  ;; for this in lisp modes.
  (global-set-key (kbd "C-c C-d") #'helpful-at-point)

  ;; Look up *F*unctions (excludes macros).
  ;;
  ;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
  ;; already links to the manual, if a function is referenced there.
  (global-set-key (kbd "C-h F") #'helpful-function))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package ctrlf
  :config) ;(ctrlf-mode nil))

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;
;; DIRED stuff ;;
;;;;;;;;;;;;;;;;;

;; (use-package dirvish
;;   ;:init (dirvish-override-dired-mode)
;;   :config
;;   (global-set-key (kbd "C-x D") 'dirvish-dwim)) ;maybe replace with just dirvish

(use-package dired-filter)

(setq dired-dwim-target t)

(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;
;; Programming Modes ;;
;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(glsl-mode . ("glslls" "--stdin"))))

(defun my-prog-hook ()
  "Custom settings for prog modes"
  (interactive)
  (hl-todo-mode 1)
  )

(add-hook 'prog-mode-hook 'my-prog-hook)

(use-package go-mode)

(use-package gnuplot)
(use-package gnuplot-mode)

(defun my-java-hook ()
  "Custom settings for java programming"
  (interactive)
  (setq indent-tabs-mode nil
	tab-width 4
	c-basic-offset 4))

(add-hook 'java-mode-hook 'my-java-hook)

(defun my-go-hook ()
  "My custom settings for go"
  (setq tab-width 4)
  )

(add-hook 'go-mode-hook 'my-go-hook)

(use-package ggtags)

(use-package yaml-mode)

(use-package haskell-mode)

(use-package sly)

;; Web Stuff ;;
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode)))

;;General programming mode configs
(add-hook 'prog-mode-hook #'subword-mode)
(c-set-offset 'case-label '+)

;;Ruby
(use-package robe
  :config
  (add-hook 'ruby-mode-hook 'robe-mode)
  (add-hook 'ruby-ts-mode-hook 'robe-mode))

(use-package bundler)

(use-package flymake-ruby
  :config
  (add-hook 'ruby-mode-hook 'flymake-ruby-load))

(use-package inf-ruby
  :config
  (add-hook 'ruby-mode-hook 'inf-ruby-minor-mode))

;;; Processing
(use-package processing-mode
  :config
  (setq processing-location "~/processing-4.3/processing-java")
  (setq processing-application-dir "~/processing-4.3/processing")
  (setq processing-sketchbook-dir "~/sketchbook")
  (add-to-list
   'color-identifiers:modes-alist
   `(processing-mode . ("" "\\_<\\([a-zA-Z_$]\\(?:\\s_\\|\\sw\\)*\\)"
			(nil font-lock-variable-name-face)))))
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(processing-mode . ("~/processing-4.3/processing-lsp" "--stdio"))))


(when *using-eglot*
  (use-package eglot-java)
  (add-hook 'java-mode-hook 'eglot-java-mode)
  (add-hook 'java-mode-hook (lambda ()
			      (setq eglot-report-progress nil)))
  (add-hook 'c++-mode-hook 'eglot-ensure)
  (add-hook 'processing-mode 'eglot-ensure))

;;;Clojure
(use-package cider)
(when *using-eglot*
  (add-hook 'clojure-mode-hook 'eglot-ensure))
(use-package paredit)
(add-hook 'clojure-mode-hook 'paredit-mode-hook)

;;Generic programming packages 
(use-package hl-todo)
(use-package flycheck-hl-todo
  :after (hl-todo))

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;
;; Completion Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Corfu ;;
(when *using-corfu*
  (unless (display-graphic-p)
    (use-package corfu-terminal
      :init (corfu-terminal-mode 1)))
  
  
  (use-package corfu
    :custom
    (corfu-cycle t)                 ; Allows cycling through candidates
    (corfu-auto t)                  ; Enable auto completion
    (corfu-auto-prefix 1)
    (corfu-auto-delay 0.0)
    (corfu-popupinfo-delay '(0.5 . 0.2))
    (corfu-preview-current 'insert) ; Do not preview current candidate
    (corfu-preselect 'prompt)
    (corfu-on-exact-match nil)      ; Don't auto expand tempel snippets
    (corfu-min-width 70)
    (corfu-max-width corfu-min-width)       ; Always have the same width
    (corfu-count 14)
    
    :init
    (global-corfu-mode)
    (corfu-history-mode)
    (corfu-popupinfo-mode) ; Popup completion info
    :config
    (setq corfu-sources
	  '(corfu-source-company-capf))))

(use-package kind-icon
  :after corfu
  :custom
  (kind-icon-use-icons t)
  (kind-icon-default-face 'corfu-default) ; Have background color be the same as `corfu' face background
  (kind-icon-blend-background nil)  ; Use midpoint color between foreground and background colors ("blended")?
  (kind-icon-blend-frac 0.08)
  :config
  (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter)) ; Enable `kind-icon')

;; Cape ;;
(use-package cape
  :after corfu
  :defer 10
  :bind ("C-c f" . cape-file)
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block))

(use-package yasnippet-capf
  :after (cape)
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;
;; Vertico Config ;;
;;;;;;;;;;;;;;;;;;;;

(when *using-vertico*
  (use-package vertico
    :init (vertico-mode)
    :config
    (setq vertico-count 20)
    (setq vertico-resize t)
    (setq vertico-cycle t)
    (setq read-file-name-completion-ignore-case t
	  read-buffer-completion-ignore-case t
	  completion-ignore-case t))
  
  (use-package marginalia
    :after vertico
    :bind (:map minibuffer-local-map
		("M-A" . marginalia-cycle))
    :init (marginalia-mode)
    :config
    (setq marginalia-align 'right))
  
  (use-package savehist
    :init (savehist-mode))
  
  (use-package all-the-icons-completion
    :after (marginalia all-the-icons)
    :hook (marginalia-mode . all-the-icons-completion-marginalia-setup)
    :init (all-the-icons-completion-mode))
  
  (use-package orderless
    :custom
    (completion-styles '(orderless basic))
    (completion-category-overrides '((file (styles basic partial-completion)))))
  
  
  (use-package consult ;probably revise this
    :bind (;; C-c bindings in `mode-specific-map'
	   ("M-g M-i" . consult-imenu-multi)
           ("C-c M-x" . consult-mode-command)
           ("C-c h" . consult-history)
           ("C-c k" . consult-kmacro)
           ("C-c m" . consult-man)
           ("C-c i" . consult-info)
           ([remap Info-search] . consult-info)
           ;; C-x bindings in `ctl-x-map'
           ("C-x M-:" . consult-complex-command)     ;; orig. repeat-complex-command
           ("C-x b" . consult-buffer)                ;; orig. switch-to-buffer
           ("C-x 4 b" . consult-buffer-other-window) ;; orig. switch-to-buffer-other-window
           ("C-x 5 b" . consult-buffer-other-frame)  ;; orig. switch-to-buffer-other-frame
           ("C-x r b" . consult-bookmark)            ;; orig. bookmark-jump
           ("C-x p b" . consult-project-buffer)      ;; orig. project-switch-to-buffer
           ;; Custom M-# bindings for fast register access
           ("M-#" . consult-register-load)
           ("M-'" . consult-register-store)          ;; orig. abbrev-prefix-mark (unrelated)
           ("C-M-#" . consult-register)
           ;; Other custom bindings
           ("M-y" . consult-yank-pop)                ;; orig. yank-pop
           ;; M-g bindings in `goto-map'
           ("M-g e" . consult-compile-error)
           ("M-g f" . consult-flymake)               ;; Alternative: consult-flycheck
           ("M-g g" . consult-goto-line)             ;; orig. goto-line
           ("M-g M-g" . consult-goto-line)           ;; orig. goto-line
           ("M-g o" . consult-outline)               ;; Alternative: consult-org-heading
           ("M-g m" . consult-mark)
           ("M-g k" . consult-global-mark)
           ("M-g i" . consult-imenu)
           ("M-g I" . consult-imenu-multi)
           ;; M-s bindings in `search-map'
           ("M-s d" . consult-find)                  ;; Alternative: consult-fd
           ("M-s D" . consult-locate)
           ("M-s g" . consult-grep)
           ("M-s G" . consult-git-grep)
           ("M-s r" . consult-ripgrep)
           ("M-s l" . consult-line)
           ("M-s L" . consult-line-multi)
           ("M-s k" . consult-keep-lines)
           ("M-s u" . consult-focus-lines)
           ;; Isearch integration
           ("M-s e" . consult-isearch-history)
           :map isearch-mode-map
           ("M-e" . consult-isearch-history)         ;; orig. isearch-edit-string
           ("M-s e" . consult-isearch-history)       ;; orig. isearch-edit-string
           ("M-s l" . consult-line)                  ;; needed by consult-line to detect isearch
           ("M-s L" . consult-line-multi)            ;; needed by consult-line to detect isearch
           ;; Minibuffer history
           :map minibuffer-local-map
           ("M-s" . consult-history)                 ;; orig. next-matching-history-element
           ("M-r" . consult-history))                ;; orig. previous-matching-history-element)
    :hook (completion-list-mode . consult-preview-at-point-mode)
    :init
    (setq register-preview-delay 0.5
          register-preview-function #'consult-register-format)
    (advice-add #'register-preview :override #'consult-register-window)
    
    (setq xref-show-xrefs-function #'consult-xref
          xref-show-definitions-function #'consult-xref)

    :config
    (consult-customize
     consult-theme :preview-key '(:debounce 0.2 any)
     consult-ripgrep consult-git-grep consult-grep
     consult-bookmark consult-recent-file consult-xref
     consult--source-bookmark consult--source-file-register
     consult--source-recent-file consult--source-project-recent-file
     ;; :preview-key "M-."
     :preview-key '(:debounce 0.4 any))
    (setq consult-narrow-key "<")) ;; "C-+"

  (use-package consult-eglot)

  (use-package consult-todo)

  (use-package embark
    :bind
    (("C-." . embark-act)         ;; pick some comfortable binding
     ("C-;" . embark-dwim)        ;; good alternative: M-.
     ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings')

    :init
    ;(add-hook 'eldoc-documentation-functions #'embark-eldoc-first-target)
    :config
    ;; Hide the mode line of the Embark live/completions buffers
    (add-to-list 'display-buffer-alist
		 '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                   nil
                   (window-parameters (mode-line-format . none)))))

  (use-package embark-consult
    :hook
    (embark-collect-mode . consult-preview-at-point-mode))
  
  (use-package emacs
    :init
    (setq enable-recursive-minibuffers t)))

;---------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("8721f7ee8cd0c2e56d23f757b44c39c249a58c60d33194fe546659dabc69eebd" default))
 '(isearch-lazy-count t)
 '(package-selected-packages
   '(consult-todo eglot glsl-mode go-mode info-colors gnuplot-mode gnuplot form-feed vterm julia-snail julia-mode ggtags catppuccin-theme sudo-edit yaml-mode haskell-mode corfu-terminal sly ox-hugo toml-mode auctex ess web-mode elcord flycheck-hl-todo hl-todo yasnippet-capf notmuch flymake-ruby bundler robe csv-mode plantuml-mode disk-usage consult-eglot rainbow-identifiers kind-icon embark-consult all-the-icons-completion yasnippet-snippets which-key vertico undo-tree sr-speedbar smartparens rainbow-mode rainbow-delimiters quickrun projectile processing-mode paredit org-view-mode org-roam org-modern org-download orderless marginalia iedit ialign helpful git-gutter-fringe format-all forge flycheck embark eglot-java dracula-theme doom-modeline dirvish dired-filter devdocs dashboard ctrlf corfu consult color-identifiers-mode cider beacon all-the-icons-dired)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(corfu-default ((t (:background "#461D4E")))))

;;; .emacs ends here
