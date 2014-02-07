;;
;; dcreemer's emacs file
;;

(defconst dc/macosx-gui-p
  (and window-system (eq 'darwin system-type)))

;; fix the PATH variable on Mac OS X gui
(when dc/macosx-gui-p
  (setenv "PATH" (shell-command-to-string "source ~/.path; echo -n $PATH"))
  (setq exec-path (append (split-string (getenv "PATH") ":") exec-path)))

;; customizations go in a separate file:
(setq custom-file (concat user-emacs-directory "custom.el"))
(load custom-file 'noerror)

;;
;; packages to load and ensure
;;

(require 'package)
(add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

(defvar my-packages '(ac-nrepl
                      auto-complete
                      cider
                      clojure-mode
                      clojure-test-mode
                      color-theme
                      cyberpunk-theme
                      erc-terminal-notifier
                      find-file-in-repository
                      go-mode
                      highlight-symbol
                      htmlize
                      ido-vertical-mode
                      jedi
                      magit
                      markdown-mode
                      oauth
                      python-mode
                      rainbow-delimiters
                      smartparens
                      smex
                      tumblesocks
                      w3m
                      yaml-mode
                      yasnippet))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;;
;; Basic Global Keys
;;
(global-set-key "\M- " 'hippie-expand)
(define-key global-map (kbd "RET") 'newline-and-indent)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key '[(meta kp-delete)] 'kill-word)

;;
;; save backups to common location, and keep more versions
;;
(setq backup-directory-alist `(("." . ,(concat user-emacs-directory "state/backups"))))
(setq delete-old-versions t
      kept-new-versions 3
      kept-old-versions 2
      version-control t)

(setq auto-save-list-file-prefix (concat user-emacs-directory "state/auto-save-list/.saves-"))

;;
;; load custom functions
;;
(load-file (concat user-emacs-directory "util.el"))

;;
;; Magit
;;
(global-set-key "\C-xg" 'magit-status)
(global-set-key "\C-xf" 'find-file-in-repository)

;;
;; UI Settings
;;

;; better directory traversal
(ido-mode t)
(setq ido-enable-flex-matching t)
(setq ido-save-directory-list-file (concat user-emacs-directory "state/ido.last"))
(ido-vertical-mode 1)
(setq ido-use-virtual-buffers t)

;;
;; smarter meta-x
(require 'smex)
(smex-initialize)
(setq smex-save-file (concat user-emacs-directory "state/smex-items"))
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; return to same point in a buffer when revisiting the file:
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (concat user-emacs-directory "state/places"))

;; remember many recent files:
(require 'recentf)
(setq recentf-max-saved-items 200
      recentf-max-menu-items 15)
(recentf-mode +1)
(global-set-key (kbd "C-c f") 'recentf-ido-find-file)

;; ensure all buffers have unique names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; turn on menu-, off tool-, and scroll-bars
(if window-system
    (menu-bar-mode 1)
  (menu-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

;; set the color theme to something nice
(require 'color-theme)
(color-theme-initialize)
(load-theme 'cyberpunk t)
(when window-system
  (set-face-attribute 'default nil :font "DejaVu Sans Mono-12"))

;; I need to edit some very large YAML files. Maximum font-lock slows that down
(setq font-lock-maximum-decoration '((yaml-mode . nil) (t . t)))

;; always show empty space at end of buffer and line
(set-default 'indicate-empty-lines t)
(setq show-trailing-whitespace t)

;; Use shift key to navigate windows:
(windmove-default-keybindings 'shift)

;; make the cursor more visible:
;(global-hl-line-mode)

(set-default 'fill-column 77)

;; turn on some disabled commands
(put 'narrow-to-defun  'disabled nil)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer     'disabled nil)

;; shell -- currently favoring ansi-term
(global-set-key (kbd "C-$") '(lambda () (interactive) (ansi-term "bash")))
;;(setq eshell-directory-name (concat user-emacs-directory "state/eshell"))
;;(setq eshell-aliases-file (concat user-emacs-directory "eshell-aliases"))

;;
;; spelling
;;
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;;
;; Code Formatting Globally:
;;

;; tabs are 8 charachters, but we never generate them.
(set-default 'c-basic-offset 4)
(set-default 'indent-tabs-mode nil)
(set-default 'tab-width 8)

(show-paren-mode 1)
(column-number-mode)
(global-rainbow-delimiters-mode)

(require 'smartparens-config)
(smartparens-global-mode 1)
(define-key sp-keymap (kbd "C-M-f") 'sp-forward-sexp)
(define-key sp-keymap (kbd "C-M-b") 'sp-backward-sexp)
(define-key sp-keymap (kbd "C-M-n") 'sp-next-sexp)
(define-key sp-keymap (kbd "C-M-p") 'sp-previous-sexp)

; auto-completion everywhere
(require 'auto-complete-config)
(ac-config-default)
(setq ac-comphist-file (concat user-emacs-directory "state/ac-comphist.dat"))

; highlight-synbols in all programming modes:
(add-hook 'prog-mode-hook 'highlight-symbol-mode)

;; yasnippet
;; (require 'yasnippet)
;; (yas-reload-all)
;; (add-hook 'prog-mode-hook 'yas-minor-mode)
;; (add-hook 'markdown-mode-hook 'yas-minor-mode)

;;
;; clojure
;;
(add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
(setq nrepl-hide-special-buffers t)
(add-hook 'clojure-mode-hook 'subword-mode) ; allow for CamelCase
(add-hook 'clojure-mode-hook 'auto-complete-mode)
(add-hook 'cider-repl-mode-hook 'subword-mode)
(add-hook 'cider-repl-mode-hook 'smartparens-mode)
(add-hook 'cider-repl-mode-hook 'auto-complete-mode)
(add-hook 'cider-repl-mode-hook 'ac-nrepl-setup)
(add-hook 'cider-mode-hook 'ac-nrepl-setup)
(eval-after-load "auto-complete"
  '(add-to-list 'ac-modes 'cider-repl-mode))

;;
;; Go
;;
(add-hook 'go-mode-hook
          (lambda ()
            (setq indent-tabs-mode t)   ; gofmt says use tabs
            (setq tab-width 4)))

;;
;; YAML
;;
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;;
;; Python
;;
(add-to-list 'auto-mode-alist '("\\.py$" . python-mode))
(setq py-electric-colon-active t)
(add-hook 'python-mode-hook
          (lambda ()
            (jedi:setup)
            (setq jedi:complete-on-dot t)
            (local-set-key "\C-c\C-d" 'jedi:show-doc)
            (local-set-key (kbd "M-SPC") 'jedi:complete)
            (setq jedi:use-shortcuts t))) ; M-. and M-,

;;
;; w3m
;;
;(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)
(global-set-key "\C-xw" 'browse-url-at-point)

;;
;; load private config:
;;
(setq dc/private-emacs-dir "~/.emacs.private/")
(when (file-exists-p dc/private-emacs-dir)
  (load-file (concat dc/private-emacs-dir "init.el")))

;;
;; start emacs server
;;
(when window-system
  (if dc/macosx-gui-p
      ;; on mac os x, the server socket needs to be set
      (setq server-socket-dir (format "/tmp/emacs%d" (user-uid))))
  (server-start))
