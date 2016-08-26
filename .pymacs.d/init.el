;; init.el --- Emacs configuration

;; RE-SET emacs directory
(setq user-init-file (or load-file-name (buffer-file-name)))
(setq user-emacs-directory (file-name-directory user-init-file))

;; The completions buffer is needed for making C-g work. I'm not yet sure why
(generate-new-buffer "*Completions*")


;; INSTALL PACKAGES
;; --------------------------------------
(require 'package)

(add-to-list 'package-archives
	     '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar pymacs-packages
  '(better-defaults ; https://github.com/technomancy/better-defaults#new-behaviour
    ein             ; jupyter notebook integration
    elpy            ; python emacs
    vline           ; visual vertical lines
    material-theme  ; ui
    markdown-mode   ; writing
    ))

(mapc #'(lambda (package)
	  (unless (package-installed-p package)
	    (package-install package)))
      pymacs-packages)

;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; THIS IS PYMACS
(elpy-enable)

;; yas custom dir
(add-to-list 'yas-snippet-dirs (concat user-emacs-directory "/snippets" ))

(add-to-list 'load-path "~/.pymacs.d/")
(require 'ui)

;; Load from normal emacs
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(require 'environment_vars)
(require 'my_functions)
(require 'keybindings)

(elpy-use-ipython)

;; init.el ends here
