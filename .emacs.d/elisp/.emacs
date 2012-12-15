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

;; Org mode setup
;;;;;;;;;;;;;;;;;
;; http://www.emacswiki.org/emacs-en/OrgAnnotateFile
(require 'org-annotate-file)
(global-set-key (kbd "C-c C-l") 'org-annotate-file)
(require 'org-setup)

;; MobilOrg start
                                        ;(require 'mobile_org_setup)

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
