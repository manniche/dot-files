;; -*- mode:lisp -*-

(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/java")
(add-to-list 'load-path "~/.emacs.d/java")

(require 'java-mode-indent-annotations)

(add-hook 'java-mode-hook 'java-mode-indent-annotations-setup)

(provide 'emacs-java)