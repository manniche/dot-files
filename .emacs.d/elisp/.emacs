(server-start)

(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/config")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")
(add-to-list 'load-path "~/.emacs.d/elisp/edit-server")
(add-to-list 'load-path "~/.emacs.d/elisp/ikiwiki")
(add-to-list 'load-path "/usr/share/emacs23/site-lisp")

;;; elpa setup
(require 'package)
(add-to-list 'package-archives
'("melpa" . "http://melpa.milkbox.net/packages/") t)

;; (setq package-archives '(("tromey" . "http://tromey.com/elpa/") 
;;                           ("gnu" . "http://elpa.gnu.org/packages/")
;;                           ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
;;; end elpa setup


;; http://www.emacswiki.org/emacs-en/OrgAnnotateFile
(require 'org-annotate-file)
(global-set-key (kbd "C-c C-l") 'org-annotate-file)
(setq org-annotate-file-storage-file "~/.org/annotated.org")



;; General programming setup
(require 'programming-setup)

;;; edit-server edit textareas from chrome in emacs
(require 'edit-server)
(edit-server-start)
;;; end edit-server

;;; MobilOrg start
(require 'mobile_org_setup)

;; ikiwiki setup
(require 'ikiwiki-org-plugin)

;; my own vars and l'a'f
(require 'environment_vars)
(require 'ui)
(require 'my_functions)
(require 'keybindings)
