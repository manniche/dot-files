(server-start)

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")
(add-to-list 'load-path "/usr/share/emacs23/site-lisp")

;; elpa setup
;;;;;;;;;;;;;
(require 'package)
(add-to-list 'package-archives
'("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)



;; Org mode setup
;;;;;;;;;;;;;;;;;
;; http://www.emacswiki.org/emacs-en/OrgAnnotateFile
(require 'org-annotate-file)
(global-set-key (kbd "C-c C-l") 'org-annotate-file)
(setq org-annotate-file-storage-file "~/.org/annotated.org")

;; MobilOrg start
(require 'mobile_org_setup)


;; General programming setup
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'programming-setup)

;; my own vars and l'a'f
(require 'environment_vars)
(require 'ui)
(require 'my_functions)
(require 'keybindings)
