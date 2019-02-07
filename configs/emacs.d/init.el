(server-start)

(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")

;; The completions buffer is needed for making C-g work. I'm not yet sure why
(generate-new-buffer "*Completions*")

;; elpa setup
;;;;;;;;;;;;;
;(require 'package)
(setq package-list
      '(pandoc-mode
	yasnippet
	evil
	projectile
	highlight
	highlight-parentheses
	powerline
	evil-leader
	markdown-mode
	linum-relative
	js2-mode
	web-mode))

(setq package-archives '(("elpy" . "http://jorgenschaefer.github.io/packages/")
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
(require 'js2-setup)

;; my own vars and l'a'f
(require 'environment_vars)
(require 'ui)
(require 'my_functions)
(require 'keybindings)
(require 'evil-keybindings)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (terraform-mode pandoc-mode elpy yasnippet yaml-mode projectile powerline markdown-mode magit linum-relative js2-mode highlight-parentheses highlight folding evil-nerd-commenter evil-leader evil-commentary dockerfile-mode csv-mode clojure-mode auctex))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
