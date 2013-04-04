;; yasnippet
(add-to-list 'load-path
              "~/.emacs.d/elpa/yasnippet")
(require 'yasnippet) ;; not yasnippet-bundle
(yas/initialize)
(yas/global-mode 1)

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

;;; markdown mode setup
(add-to-list 'auto-mode-alist
 (cons (concat "\\." (regexp-opt '("md" "markdown") t) "\\'")
 'markdown-mode))
;;; end markdown mode setup


(provide 'programming-setup)
