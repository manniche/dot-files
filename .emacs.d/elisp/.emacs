(server-start)

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")

;; The completions buffer is needed for making C-g work. I'm not yet sure why
(generate-new-buffer "*Completions*")

;; elpa setup
;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)

;;;;;;;;;;;;;;;;;
;; always ido
(require 'ido)
(ido-mode t)

;; General programming setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'programming-setup)

;; my own vars and l'a'f
(require 'environment_vars)
(require 'ui)
(require 'my_functions)
(require 'keybindings)
; Load el4r, which loads Xiki
(add-to-list 'load-path "/home/semn/.rvm/gems/ruby-1.9.3-p448/gems/trogdoro-el4r-1.0.10/data/emacs/site-lisp/")
(require 'el4r)
(el4r-boot)
(el4r-troubleshooting-keys)
