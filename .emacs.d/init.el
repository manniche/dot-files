(server-start)

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")

;; The completions buffer is needed for making C-g work. I'm not yet sure why
(generate-new-buffer "*Completions*")

;; elpa setup
;;;;;;;;;;;;;
;(require 'package)
(setq package-list '(yasnippet clojure-mode evil projectile highlight highlight-parentheses powerline evil-leader markdown-mode linum-relative))

(setq package-archives '(("elpa" . "http://tromey.com/elpa/")
                         ("elpy" . "http://jorgenschaefer.github.io/packages/")
                         ("gnu" . "http://elpa.gnu.org/packages/")
                         ("melpa" . "http://melpa.org/packages/")
                         ))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

; install the required packages
(dolist (package package-list)
  (unless (package-installed-p package)
    (package-install package)))

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


