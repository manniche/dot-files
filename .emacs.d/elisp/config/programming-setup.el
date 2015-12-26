;; yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(setq yas-snippet-dirs
      '("~/.emacs.d/plugins/yasnippet/snippets"               
        "~/.emacs.d/elisp/yasnippet/snippets"
        ))
(yas-global-mode 1)

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

;;; python mode setup
(add-to-list 'auto-mode-alist
 (cons (concat "\\." (regexp-opt '("py" "ipy") t) "\\'")
 'python-mode))
(add-hook 'elpy-mode-hook (load-file "~/.emacs.d/elisp/config/emacs-python.el"))
;;; end python mode setup

;;; markdown mode setup
(add-to-list 'auto-mode-alist
 (cons (concat "\\." (regexp-opt '("md" "markdown") t) "\\'")
 'markdown-mode))
;;; end markdown mode setup

;;; ruby/rails setup
(add-hook 'speedbar-mode-hook
          (lambda()
            (speedbar-add-supported-extension "\\.rb")
            (speedbar-add-supported-extension "\\.ru")
            (speedbar-add-supported-extension "\\.erb")
            (speedbar-add-supported-extension "\\.rjs")
            (speedbar-add-supported-extension "\\.rhtml")
            (speedbar-add-supported-extension "\\.rake")))

;; projectile: https://github.com/bbatsov/projectile
(projectile-global-mode)

;; define projman projects
 (setq projman-projects
       '(("site"
          :root "~/sites/text.manniche.net"
          :type markdown
          :open-hook (lambda () (global-auto-revert-mode 1))
          :compile-command "python fabfile.py deploy"
           )))

;; vi-mode
(require 'evil)
(evil-mode 1)

(provide 'programming-setup)
