(server-start)

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")
(add-to-list 'load-path "~/.emacs.d/elisp/edit-server")

(add-to-list 'load-path "/usr/share/emacs23/site-lisp")

;; latex loadfiles
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

;;; elpa setup
(require 'package)
(setq package-archives '(("tromey" . "http://tromey.com/elpa/") 
                          ("gnu" . "http://elpa.gnu.org/packages/")
                          ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
;;; end elpa setup

;;; clojure mode setup
(add-to-list 'auto-mode-alist
 (cons (concat "\\." (regexp-opt '("clj" "cljs") t) "\\'")
 'clojure-mode))
(add-hook 'clojure-mode-hook (load-file "~/.emacs.d/elisp/config/emacs-clojure.el"))
;;; end clojure mode setup

;;; java mode setup
(add-to-list 'auto-mode-alist
 (cons (concat "\\." (regexp-opt '("java" "jsp") t) "\\'")
 'java-mode))
(add-hook 'java-mode-hook (load-file "~/.emacs.d/elisp/config/emacs-java.el"))
;;; end java mode setup

;;; eclim setup
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/eclim"))
;; only add the vendor path when you want to use the libraries provided with emacs-eclim
;;(add-to-list 'load-path (expand-file-name "~/.emacs.d/elisp/eclim/vendor"))
;;(require 'eclim)
;;(setq eclim-auto-save t)
;;(global-eclim-mode t)
;;; end eclim setup

;;; edit-server edit textareas from chrome in emacs
(require 'edit-server)
(edit-server-start)
;;; end edit-server

;; my own vars and l'a'f
(require 'environment_vars)
(require 'ui)
(require 'my_functions)
(require 'keybindings)
