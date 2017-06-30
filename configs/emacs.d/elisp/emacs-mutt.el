;; -*- mode:lisp -*-

(add-to-list 'load-path "~/.emacs.d/elisp/")
(add-to-list 'load-path "~/.emacs.d/elisp/mutt")

;;load basic config
;(require 'init)
;(require 'ui)
(require 'my_functions)
;(require 'keybindings)
;(require 'environment_vars)

;;activate keybindings
;(my-keybindings)

(require 'mutt)
(setq mutt-mode t)