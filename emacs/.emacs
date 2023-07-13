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

;;;; NOTES ABOUT THE COMMENT CONVENTIONS
;-----------------------------------------------
; ;Single semicolons (;) should be used (format "message" format-args)or inline comments.
; ;Double semicolons (;;) should be used for line comments.
; ;Triple semicolons (;;;) should be used for "comments that should be considered a heading by Outline minor mode"
; ;Quadruple semicolons (;;;;) should be used for headings of major sections of a program.
;----------------------------------------------

;;;Sly stuff
(use-package sly)

;;; Dired stuff
(use-package dired-single)
(use-package all-the-icons-dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package dirvish
  :config (dirvish-override-dired-mode))

;;; Processing
(use-package processing-mode
  :config
  (setq processing-location "~/processing-4.2/processing-java")
  (setq processing-application-dir "~/processing-4.2/processing")
  (setq processing-sketchbook-dir "~/sketchbook")
  (add-hook 'processing-mode-hook 'company-mode 'company-box-mode)
  (add-hook 'processing-mode-hook 'glasses-mode)
  (add-hook 'processing-mode-hook #'lsp-deferred))

(with-eval-after-load 'lsp-mode
  (add-to-list 'lsp-language-id-configuration
	       '(processing-mode . "processing"))
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-stdio-connection "/usr/share/processing/processing-lsp")
		    :activation-fn (lsp-activate-on "processing")
		    :server-id 'processing)))

;;;Org mode stuff
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

;;; Projectile
(use-package projectile
  :init
  (projectile-mode 1)
  :bind (:map projectile-mode-map
	      ("s-p" . projectile-command-map)
	      ("C-c p" . projectile-command-map)))

(use-package treemacs-projectile
  :after projectile)

;;; Random unsorted stuff
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;;Ivy
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

;;;;Code:
(setq inferior-lisp-program "sbcl") ;;set the common lisp to SBCL
(tool-bar-mode -1) ;; remove the tool bar
(setq undo-limit 240000) ;; Change the undo limit to 240000 bytes - might need tweaking
;(global-set-key (kbd "C-c M-x") 'execute-extended-command)
(global-set-key (kbd "C-c C-s") 'sly)
;; Extra sections that's not required
(add-to-list 'load-path "~/.emacs.d/extra/tracker-mode/") ;;probs remove, was for funny joke
(delete-selection-mode 1)
(setq org-support-shift-select t)
(setq org-image-actual-width 400)

;;;; Visuals


;;Git gutter stuff
(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))

;;pdf-tools
(use-package pdf-tools
  :config
  (pdf-tools-install))

;;Common lisp

;;Uncomment this if stop using sly
;;(use-package slime
;;  :config
;;  (setq inferior-lisp-program "sbcl")
;;  (add-to-list 'auto-mode-alist '("\\.lisp\\'" . slime-mode))
;;  (setq slime-contribs '(slime-fancy)))

;;beacon mode
(use-package beacon
  :config
  (beacon-mode 1)
  (setq beacon-size 40)
  (setq beacon-blink-duration 1))


;; Screen size on startup
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(setq initial-frame-alist default-frame-alist)

;;svg fix (might not be needed when 29 comes out and school updates)
(setq image-types (cons 'svg image-types))

;;Hopefully improvements to autocomplete and stuff
(setq read-process-output-max (* 1024 1024)) ;; 1mb

;;basic settings
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)

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

;;straight startup stuff
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;;start other stuff

(use-package projectile
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
	      ("C-c p" . projectile-command-map)));;poss configure idk

;;treemacs used to be here, it's dead now

;;Uncomment if I ever use persp mode
;(use-package treemacs-persp ;;treemacs-perspective if you use perspective.el vs. persp-mode
;  :after (treemacs persp-mode) ;;or perspective vs. persp-mode
;  :ensure t
;  :config (treemacs-set-scope-type 'Perspectives))

;;Uncomment if I ever use tab bars
;(use-package treemacs-tab-bar ;;treemacs-tab-bar if you use tab-bar-mode
;  :after (treemacs)
;  :ensure t
;  :config (treemacs-set-scope-type 'Tabs))

(use-package all-the-icons)

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom)
  (setq which-key-idle-delay 0.2))

;;LSP STUFF
(use-package lsp-mode
  :commands lsp
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook
  ((ruby-mode
    c++-mode
    java-mode
    c-mode
    ) . lsp-deferred)
  :config
  (setq lsp-prefer-flymake nil)
  (setq lsp-log-io nil)
  (setq gc-cons-threshold 100000000) ;;maybe edit this to try out some stuff
  (setq lsp-ruby-stdio-command '("solargraph" "stdio")
	lsp-solargraph-library-directories '("~/.local/share/gem"))
  (lsp-enable-which-key-integration t))
  
  (with-eval-after-load 'lsp-mode
    (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration))


(use-package lsp-ui
  :commands lsp-ui-mode
 ;; :hook (lsp-mode . lsp-ui-mode)
  :config
  (setq lsp-ui-doc-enable t)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05))
 ; (setq lsp-ui-doc-position 'bottom)
 ; (setq lsp-ui-sideline-enable nil)
 ; (setq lsp-ui-sideline-show-hover nil)

(use-package lsp-java
  :after lsp
  :config (add-hook 'java-mode-hook 'lsp))

(use-package lsp-treemacs
  :after lsp)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)

;;; Flycheck stuff
(use-package flycheck
  :init (add-hook 'after-init-hook #'global-flycheck-mode))
  
;; (setq lsp-message-project-root-warning t)
;; (setq lsp-message-project-root-error t)

(global-set-key (kbd "C-c C-d") 'lsp-describe-thing-at-point)

(use-package yasnippet)
(use-package yasnippet-snippets)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode)
  (setq company-minimum-prefix-length 1)
  (setq company-idle-delay 0.0)) ;;probably tweak these

(use-package company-box
  :hook (company-mode . company-box-mode)
  :config (setq company-box-icons-alist 'company-box-icons-all-the-icons))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   '("ec101eeff0195d92c3dc0c1c60edb1a84fa2adbbe8fdfea2a423aa95d1edc4d7" default))
 '(global-display-line-numbers-mode t)
 '(package-selected-packages
   '(minimap centaur-tabs projectile page-break-lines use-package dashboard sublimity catppuccin-theme ##))
 '(size-indication-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'sublimity)
(require 'sublimity-scroll)
(sublimity-mode 1)


(use-package octicons)
(use-package nerd-icons)


;;dashboard stuff
(use-package dashboard
  :config
  (setq dashboard-center-content t)
  (setq dashboard-icon-type 'all-the-icons) ;; use `all-the-icons' package
  (setq dashboard-display-icons-p t) ;; display icons on both GUI and terminal
  ;;(setq dashboard-icon-type 'nerd-icons) ;; use `nerd-icons' package
  ;;(setq dashboard-set-heading-icons t)
  ;;(setq dashboard-set-file-icons t)
  ;;(setq dashboard-set-navigator t)
  ;; (setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*"))) ;For if I ever use the Daemon
  (dashboard-setup-startup-hook))

(use-package centaur-tabs
  :ensure t
  :demand
  :config
  (centaur-tabs-mode t)
  (centaur-tabs-headline-match)
  (setq centaur-tabs-style "slant")
  (setq centaur-tabs-set-icons t)
  (setq centaur-tabs-set-bar 'under)
  (setq x-underline-at-descent-line t)
  (setq centaur-tabs-cycle-scope 'tabs)
  :bind
  ("C-<iso-lefttab>" . centaur-tabs-backward)
  ("C-<tab>" . centaur-tabs-forward))

(winner-mode 1)

(load-theme 'catppuccin t)
