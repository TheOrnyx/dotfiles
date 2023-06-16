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

;;;Code:
(setq inferior-lisp-program "sbcl") ;;set the common lisp to SBCL

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

(use-package sly)

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

;;treemacs
(use-package treemacs
  :ensure t
  :defer t
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :config
  (treemacs-follow-mode t)
  (treemacs-filewatch-mode t)
  (treemacs-fringe-indicator-mode 'always)
  (when treemacs-python-executable
    (treemacs-git-commit-diff-mode t))
  :bind
  (:map global-map
        ("M-0"       . treemacs-select-window)
        ("C-x t 1"   . treemacs-delete-other-windows)
        ("C-x t t"   . treemacs)
        ("C-x t d"   . treemacs-select-directory)
        ("C-x t B"   . treemacs-bookmark)
        ("C-x t C-t" . treemacs-find-file)
        ("C-x t M-t" . treemacs-find-tag)))

(use-package treemacs-projectile
  :after (treemacs projectile)
  :ensure t)

(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once)
  :ensure t)

(use-package treemacs-magit
  :after (treemacs magit)
  :ensure t)

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

(use-package all-the-icons
  :if (display-graphic-p))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))
  ;(which-key-setup-minibuffer)
  ;(setq which-key-popup-type 'minibuffer))
;;possibly expand this

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
  (setq lsp-ui-doc-enable nil)
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

(use-package flycheck
  :init (global-flycheck-mode)
  :config
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (setq flycheck-display-errors-delay 0.2))
;; (setq lsp-message-project-root-warning t)
;; (setq lsp-message-project-root-error t)

(global-set-key (kbd "C-c C-d") 'lsp-describe-thing-at-point)

(use-package yasnippet)
(use-package yasnippet-snippets)
(yas-reload-all)
(add-hook 'prog-mode-hook #'yas-minor-mode)

(use-package company
  :config
  (add-hook 'after-init-hook 'global-company-mode))


;;Fix this if I ever decide to stop using sly
;;(use-package slime-company
;;  :after (slime company)
;;  :config
;;  (setq slime-company-completion 'fuzzy
;;        slime-company-after-completion 'slime-company-just-one-space)
;;  (push 'company-slime company-backends))

;;(use-package lsp-ivy)

;;(defun efs/lsp-mode-setup ()	       
;;  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
;;  (lsp-headerline-breadcrumb-mode))

;; (use-package company
;;   :after lsp-mode
;;   :hook (prog-mode . company-mode)
;;   :bind (:map company-active-map
;;          ("<tab>" . company-complete-selection))
;;         (:map lsp-mode-map
;;          ("<tab>" . company-indent-or-complete-common)))
 ; :custom
 ; (company-minimum-prefix-length 1)
 ; (company-idle-delay 0.0))

;(use-package company-box
;  :hook (company-mode . company-box-mode))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   '("ec101eeff0195d92c3dc0c1c60edb1a84fa2adbbe8fdfea2a423aa95d1edc4d7" default))
 '(package-selected-packages
   '(minimap centaur-tabs projectile page-break-lines use-package dashboard sublimity catppuccin-theme ##)))
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

(straight-use-package
 '(block-nav :type git :host github :repo "nixin72/block-nav.el")
 :config
 (progn
   (setf block-nav-move-skip-shallower t
        block-nav-center-after-scroll t)))

;;(straight-use-package 'helm)

(winner-mode 1)

(load-theme 'catppuccin t)


