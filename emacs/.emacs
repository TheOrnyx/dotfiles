;;; .emacs --- My Emacs Config File
;; Author: Zaki Si-Lounis <cthulhu345@gmail.com>

;;; Commentary:

;; TODO ::
;;
;; possibly switch to init.el
;; ELECTRIC MODE PARENTHESIS BLAHHHH
;; Probably switch around my use-package to use hooks and stuff to improve load time.
;; Switch to an ORG file for easy reading and sorting OR switch stuff into seperate files

;;; Code:
(setq gc-cons-threshold (* 50 1000 1000)) ;; set garbage collection high at beginning
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
	(c "https://github.com/tree-sitter/tree-sitter-c")
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
	(yaml "https://github.com/ikatyang/tree-sitter-yaml")
	(gdshader "https://github.com/GodOfAvacyn/tree-sitter-gdshader")))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;  Controllers for different sections ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defvar *using-eglot* t) ;using eglot
(defvar *using-corfu* t)
(defvar *using-vertico* t)
(defvar *using-projectile* t)
(defvar *using-project.el* nil)

;;;;;;;;;;;;;;;;;;;;;;;;;
;; Functions for stuff ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

(defun prompt-for-eglot ()
  "Prompt the user for activating eglot."
  (interactive)
  (unless (eglot-current-server)
    (when (y-or-n-p "Enable eglot?")
      (eglot-ensure))))

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;
;; Theme and UI stuff ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;Modeline
(use-package doom-modeline
  :config
  (doom-modeline-mode 1)
  (setq doom-modeline-support-imenu t)
  (setq doom-modeline-battery t)
  (setq doom-modeline-lsp-icon t)
  )

(use-package dracula-theme)

(setq-default inhibit-startup-screen t)
(setq inhibit-splash-screen t)
(setq display-battery-mode 1)
(setq calendar-week-start-day 1)
(display-time-mode 1)
(display-battery-mode 1)

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;
;; Custom Keybinds ;;
;;;;;;;;;;;;;;;;;;;;;

(global-set-key (kbd "C-x C-r") 'recentf)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key [remap dabbrev-expand] 'hippie-expand) ;Rebind to use hippie-expand
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "C-M-z") 'zap-to-char)
(global-set-key (kbd "M-Z") 'zap-to-char)
(global-set-key (kbd "M-i") 'imenu)				;;Binding for imenu

;; lisp kinda stuff (sexy expressions 🤪)
(global-set-key (kbd "M-<right>") 'paredit-forward-slurp-sexp)
(global-set-key (kbd "M-<left>") 'paredit-backward-slurp-sexp)

(global-set-key (kbd "C-c a") 'org-agenda)

;; Stop the stupid suspend-emacs bind
(global-set-key (kbd "C-z") (lambda () (interactive)
			      (message-box "Good one dumbass, if I hadn't fixed this it would've suspended the frame clown")))

;; eglot keybinds
(with-eval-after-load 'eglot
  (keymap-set eglot-mode-map "C-c C-e r" 'eglot-rename)
  (keymap-set eglot-mode-map "C-c C-e a" 'eglot-code-actions))

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Code And Configurations ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; TODO - maybe write a like "jump to next instance of character" function

(setq doc-view-resolution 100) ;; better pdf resolution

(setq ispell-program-name "hunspell")
(setq ispell-dictionary "en_NZ")

(setq image-use-external-converter 1)

;; Backup stuff
(setq backup-directory-alist '(("." . "~/.backups/emacs/")))
(column-number-mode 1)

;; Add ansi color to compilation buffer
(require 'ansi-color)
(defun colorize-compilation-buffer ()
  "Apply ansi-color to the compilation buffer."
  (ansi-color-apply-on-region compilation-filter-start (point)))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

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

(defun open-terminal-here ()
  "Opens an alacritty session with the current directory set"
  (interactive)
  (call-process "alacritty" nil 0 nil "--working-directory" default-directory))

(defun open-nemo-here ()
  "Opens nemo aka my file manager at the current directory"
  (interactive)
  (call-process "nemo" nil 0 nil default-directory))

(recentf-mode 1)
(setq recentf-max-saved-items 200)
(run-at-time nil (* 5 60) 'recentf-save-list)

(winner-mode 1)
(setq confirm-kill-emacs #'yes-or-no-p) ;;Confirm exits
(setq shell-file-name "/bin/bash") ;; Fixes ripgrep issues

;; GPG stuff
(require 'epa-file)
(epa-file-enable)
(setq epg-pinentry-mode 'loopback)
(setq epg-gpg-program "gpg2")
(setq auth-sources '("~/.authinfo.gpg")) ;; Sets authinfo file to gpg one

(setq save-interprogram-paste-before-kill t) ;; make copying between other programs and emacs work when killing
 
(defun kill-buffer-path ()
  "Copy the current buffer path."
  (interactive)
  (kill-new (buffer-file-name)))

(add-to-list 'load-path "~/.emacs.d/extra/")

(setq next-line-add-newlines t)

(setq inferior-lisp-program "sbcl")				;;set the common lisp to SBCL

(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

;; Smerge stuff
(eval-after-load 'smerge-mode
  (lambda () 
    (setq smerge-command-prefix (kbd "C-c C-s"))))

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;
;; Important Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;

;; Magit
(use-package magit)

;; Forge
(use-package forge
  :after magit
  :config
  (setq forge-alist '(("github.com" "api.github.com" "github.com" forge-github-repository)
		      ("gitlab.com" "gitlab.com/api/v4" "gitlab.com" forge-gitlab-repository)
		      ("gitlab.ecs.vuw.ac.nz" "gitlab.ecs.vuw.ac.nz/api/v4" "gitlab.ecs.vuw.ac.nz" forge-gitlab-repository))))

;; Ediff configuration
(setq ediff-window-setup-function 'ediff-setup-windows-plain)


;; Ripgrep
(use-package rg)

;; Corfu ;;
(when *using-corfu*
  ;; Add shit for my phone
  (unless (display-graphic-p)
    (use-package corfu-terminal
      :init (corfu-terminal-mode 1)))

  (use-package corfu
    :custom
    (corfu-cycle t)                 ; Allows cycling through candidates
    (corfu-auto t)                  ; Enable auto completion
    (corfu-auto-prefix 1)
    (corfu-auto-delay 0.0)
    (corfu-popupinfo-delay 0)
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
	  '(corfu-source-company-capf))
    :bind
    (:map corfu-map
	  ("TAB" . nil))))

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
  ;; :defer 10
  :bind ("C-c f" . cape-file)
  :init
  (add-to-list 'completion-at-point-functions #'cape-dabbrev)
  (add-to-list 'completion-at-point-functions #'cape-file)
  (add-to-list 'completion-at-point-functions #'cape-elisp-block)
  (add-to-list 'completion-at-point-functions #'cape-dict))

;; (use-package yasnippet-capf
;;   :after (cape)
;;   :config
;;   (add-to-list 'completion-at-point-functions #'yasnippet-capf))

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

  
  (use-package orderless
    :custom
    (completion-styles '(orderless basic))
    (completion-category-overrides '((file (styles basic partial-completion)))))

  (use-package consult-flycheck)

  ;; Consult
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
           ("M-g f" . consult-flycheck)               ;; Alternative: consult-flycheck
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

  (use-package consult-projectile
    :after (consult projectile)
    :config
    (global-set-key [remap projectile-find-file] 'consult-projectile-find-file)
    (global-set-key [remap projectile-switch-project] 'consult-projectile-switch-project))

  (use-package consult-todo)

  (use-package embark
    :bind
    (("C-." . embark-act)         ;; pick some comfortable binding
     ("C-;" . embark-dwim)        ;; good alternative: M-.
     ("C-h B" . embark-bindings)) ;; alternative for `describe-bindings')

    :init
    ;(add-hook '-documentation-functions #'embark-eldoc-first-target)
    :config
    ;; Hide the mode line of the Embark live/completions buffers
    (add-to-list 'display-buffer-alist
		 '("\\`\\*Embark Collect \\(Live\\|Completions\\)\\*"
                   nil
                   (window-parameters (mode-line-format . none)))))

  (use-package embark-consult
    :hook
    (embark-collect-mode . consult-preview-at-point-mode)))

;---------------------------------------------------------

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Org Mode Configs and Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(use-package org
  :custom
  ((org-log-done t)
   (org-support-shift-select t)
   (org-image-actual-width 400)
   (org-startup-indented 1)))

(defun my-org-hook ()
  "My hook for org mode stuff"
  (setq org-indent-mode 1)
  (setq fill-column 100)
  (auto-fill-mode 1))
(add-hook 'org-mode-hook 'my-org-hook)

;; TODO - change this to add like spelling to corfu and tweak some of the settings
(defun my-writing-hook ()
  "My hook for writing modes (mostly org mode)"
  (flyspell-mode 1))
;; (setq corfu-auto-delay 0.5))
;; (setq corfu-auto nil))
(add-hook 'text-mode-hook 'my-writing-hook)



(use-package org-modern
  :config
  (add-hook 'org-mode-hook #'org-modern-mode)
  (add-hook 'org-agenda-finalize-hook #'org-modern-agenda))

(use-package org-download
  :config
  (add-hook 'dired-mode-hook 'org-download-enable)
  (setq org-download-image-latex-width 5)
  (setq org-download-image-dir "./img")
  (setq org-download-heading-lvl nil))

(use-package org-roam
  :init
  (setq org-roam-v2-ack t)
  :custom
  (org-roam-directory "~/RoamNotes")
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n i" . org-roam-node-insert))
  :config
  (org-roam-db-autosync-enable))

;; Syntax highlighting and stuff
(require 'ox-latex)
(add-to-list 'org-latex-packages-alist '("" "minted"))
;; (setq org-latex-listings 'minted)
(setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;;;
;; Extra Misc Packages ;;
;;;;;;;;;;;;;;;;;;;;;;;;;

;; Elfeed - RSS reader :3
(use-package elfeed
  :config
  (setq elfeed-search-filter "@6-months-ago"))

;; Icons
(use-package nerd-icons)

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-dired
  :after nerd-icons
  :hook
  (dired-mode . nerd-icons-dired-mode))

;;TOML
(use-package toml-mode)

;;For working with R
(use-package ess)

;;Discord prescence
(use-package elcord
  :config
  (elcord-mode)
  (setq elcord-idle-message "probably dead tbh"))

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


(use-package color-identifiers-mode
  :config
  (add-to-list
   'color-identifiers:modes-alist
   `(java-ts-mode . ("" "\\_<\\([a-zA-Z_$]\\(?:\\s_\\|\\sw\\)*\\)"
                     (nil font-lock-variable-name-face))))
  (add-to-list
   'color-identifiers:modes-alist
   `(glsl-mode . ("" "\\_<\\([a-zA-Z_$]\\(?:\\s_\\|\\sw\\)*\\)"
                     (nil font-lock-variable-name-face))))
  (add-hook 'after-init-hook 'global-color-identifiers-mode))

(use-package ialign
  :config
  (global-set-key (kbd "C-c l") #'ialign))

(use-package sr-speedbar
  :config
  (setq sr-speedbar-right-side nil)
  (global-set-key (kbd "C-c t") 'sr-speedbar-toggle))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.1))


(use-package devdocs
  :config (global-set-key (kbd "C-h z") 'devdocs-lookup))

(use-package quickrun
  :bind ("C-c r" . quickrun))

(use-package rainbow-mode
  :custom
  (rainbow-mode 1))

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

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;
;; DIRED stuff ;;
;;;;;;;;;;;;;;;;;

(use-package dired-filter)
(setq dired-dwim-target t)

;---------------------------------------------------------
;;;;;;;;;;;;;;;;;;;;;;;
;; Programming Modes ;;
;;;;;;;;;;;;;;;;;;;;;;;

;; Forth
(use-package forth-mode)

;; Rust
(use-package rust-mode)

;; Arm assembly mode (has to be cloned from git@github.com:charJe/arm-mode.git)
(add-to-list 'load-path "~/.emacs.d/elpa/arm-mode")
(require 'arm-mode)


;; Zig <3
(use-package zig-mode
  :config
  (setq zig-format-on-save nil))

;; OCAML modes
(use-package tuareg)
(use-package utop)

(add-to-list 'auto-mode-alist '("\\.vs\\'" . glsl-mode))
(add-to-list 'auto-mode-alist '("\\.fs\\'" . glsl-mode))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
	       '(glsl-mode . ("glsl_analyzer"))))

;; DAPE MODE
;; TO FIX JAVA SEE HERE https://github.com/svaante/dape/issues/78#issuecomment-1966786597
(use-package dape
  :config
  (setq dape-cwd-fn 'projectile-project-root))

(use-package go-mode)

(use-package gnuplot)
(use-package gnuplot-mode)

(use-package yaml-mode)

(use-package markdown-mode) ;; needed for eldoc rendering

(use-package mermaid-mode) ;; Used for markdown mermaid graphs

(use-package haskell-mode)

(use-package sly)

;; Web Stuff ;;
(use-package web-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode)))

(use-package emmet-mode)

(use-package impatient-mode) ; for web hotreloading

(use-package smartparens
  :init (require 'smartparens-config)
  :config (add-hook 'prog-mode-hook #'smartparens-mode))

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
  ;; (add-hook 'java-mode-hook 'eglot-java-mode)
  (add-hook 'java-mode-hook (lambda ()
			      (setq eglot-report-progress nil)
			      (unless (eglot-current-server)
				(when (y-or-n-p "Enable eglot?")
				  (eglot-java-mode)))))
  (add-hook 'c++-mode-hook 'prompt-for-eglot)
  (add-hook 'processing-mode 'eglot-ensure)

  ;; (add-to-list 'eglot-server-programs
  ;; 	       `((java-mode java-ts-mode) .
  ;; 	       ("jdtls"
  ;; 		:initializationOptions
  ;; 		(:bundles ["/home/Ornyx/Documents/compiling/java-debug/com.microsoft.java.debug.plugin/target/com.microsoft.java.debug.plugin-0.51.1.jar"]))))
  )

;;;Clojure
(use-package cider)
(when *using-eglot*
  (add-hook 'clojure-mode-hook 'prompt-for-eglot))
(use-package paredit)


;;Generic programming packages 
(use-package hl-todo)
(use-package flycheck-hl-todo
  :after (hl-todo))

;; GODOT stuff
(use-package gdscript-mode
  :hook (gdscript-mode . prompt-for-eglot)
  :config
  (setq gdscript-godot-executable "/usr/bin/godot"))

;; Prog mode hooks
(defun my-prog-hook ()
  "Custom settings for prog modes"
  (interactive)
  (hl-todo-mode 1)
  (subword-mode 1))
  ;; (c-set-offset 'case-label '+))
(add-hook 'prog-mode-hook 'my-prog-hook)

(defun my-java-hook ()
  "Custom settings for java programming"
  (interactive)
  (setq indent-tabs-mode nil
	tab-width 4
	c-basic-offset 4)
  (c-set-offset 'inexpr-class 0))
(add-hook 'java-mode-hook 'my-java-hook)

(defun my-go-hook ()
  "My custom settings for go"
  (setq tab-width 4))
(add-hook 'go-mode-hook 'my-go-hook)

(defun set-go-wasm-env ()
  "Set the environment variables GOOS and GOARCH to properly program with JS and WASM."
  (interactive)
  (setenv "GOOS" "js")
  (setenv "GOARCH" "wasm"))

(defun my-c-hook ()
  "My hook for C programming."
  ;; (setq tab-width 4)
  ;; (c-set-style "stroustrup")
  ;; (setq c-basic-offset 4)
  (setq eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider)))
(add-hook 'c-mode-hook 'my-c-hook)

(defun my-cpp-hook ()
  "My hook for Cpp programming."
  (setq tab-width 4)
  (setq c-basic-offset 4)
  (c-set-style "stroustrup")
  (setq eglot-ignored-server-capabilities '(:documentOnTypeFormattingProvider)))
(add-hook 'c++-mode-hook 'my-cpp-hook)

(with-eval-after-load 'glsl-mode
  (add-hook 'glsl-mode-hook 'my-cpp-hook))

(defun my-asm-mode-hook ()
  ;; you can use `comment-dwim' (M-;) for this kind of behaviour anyway
  (local-unset-key (vector asm-comment-char))
  ;; asm-mode sets it locally to nil, to "stay closer to the old TAB behaviour".
  (setq tab-always-indent (default-value 'tab-always-indent)))

(add-hook 'asm-mode-hook #'my-asm-mode-hook)

(defun my-rust-mode-hook ()
  (setq indent-tabs-mode nil))
(add-hook 'rust-mode-hook #'my-rust-mode-hook)

;---------------------------------------------------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(Man-notify-method 'pushy)
 '(column-number-mode t)
 '(custom-enabled-themes '(dracula))
 '(custom-safe-themes
   '("603a831e0f2e466480cdc633ba37a0b1ae3c3e9a4e90183833bc4def3421a961"
     "8721f7ee8cd0c2e56d23f757b44c39c249a58c60d33194fe546659dabc69eebd"
     default))
 '(display-battery-mode t)
 '(display-time-mode t)
 '(elcord-quiet t)
 '(elcord-use-major-mode-as-main-icon t)
 '(elfeed-feeds
   '("https://jcgt.org/feed.xml" "https://ziglang.org/devlog/index.xml"
     "https://normalsville.the-comic.org/rss"))
 '(global-display-line-numbers-mode t)
 '(isearch-lazy-count t)
 '(org-agenda-files
   '("/home/Ornyx/.dotfiles/emacs/.emacs.d/agenda/todo.org"
     "/home/Ornyx/.dotfiles/emacs/.emacs.d/agenda/assignments.org"))
 '(package-selected-packages
   '(ac-ispell auctex auto-complete-auctex beacon blackjack bundler
	       catppuccin-theme centered-window cider cloc cmake-mode
	       color-identifiers-mode compiler-explorer consult
	       consult-eglot consult-flycheck consult-flyspell
	       consult-projectile consult-todo corfu corfu-terminal
	       cowsay csv-mode ctrlf dape dashboard devdocs
	       dired-filter dirvish disk-usage doom-modeline
	       dracula-theme dts-mode eat edit-indirect eglot
	       eglot-java elcord eldoc-box eldoc-cmake elfeed embark
	       embark-consult emmet-mode engrave-faces ess
	       fancy-compilation flycheck flycheck-hl-todo
	       flymake-ruby forge form-feed format-all forth-mode
	       gdscript-mode ggtags git-gutter-fringe glsl-mode
	       gnuplot gnuplot-mode go-imenu go-impl go-mode
	       gradle-mode groovy-mode haskell-mode helpful highlight
	       highlight-doxygen highlight-indent-guides hl-todo
	       ialign iedit impatient-mode info-colors insert-random
	       intel-hex-mode javadoc-lookup journalctl-mode
	       julia-mode julia-snail kind-icon landmark magit
	       marginalia markdown-mode maven-test-mode mermaid-mode
	       nerd-icons-completion nerd-icons-dired notmuch olivetti
	       orderless org-contrib org-download org-modern org-ref
	       org-view-mode ox-extra ox-hugo paredit plantuml-mode
	       poker processing-mode projectile quickrun
	       rainbow-delimiters rainbow-identifiers rainbow-mode rg
	       robe rust-mode sly smartparens smerge sr-speedbar
	       stumpwm-mode sudo-edit toml-mode tuareg utop vertico
	       web-mode which-key yaml-mode yasnippet-capf
	       yasnippet-snippets zig-mode))
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Source Code Pro" :foundry "ADBO" :slant normal :weight regular :height 113 :width normal))))
 '(corfu-border ((t (:background "gray33"))))
 '(corfu-default ((t nil)))
 '(eldoc-box-body ((t (:background "#282a36")))))

;;; .emacs ends here
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line

(setq gc-cons-threshold (* 2 1000 1000)) ;; set low again after finish initalizing
;;.emacs ends here
