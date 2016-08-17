;; yasnippet
(require 'yasnippet) ;; not yasnippet-bundle
(setq yas-snippet-dirs
      '("~/.emacs.d/snippets"               
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

;;;javascript mode setup
(add-to-list 'auto-mode-alist
  (cons (concat "\\." (regexp-opt '("js") t) "\\'")
   'js2-mode))

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

(linum-relative-mode 1)

;;;;;;;;;;;;;;;;
;; bm-mode

(require 'bm)
(require 'bm-ext)
;;bookmarks only places mark at the left
(setq bm-highlight-style (quote bm-highlight-only-fringe))
;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)
 
;; Loading the repository from file when on start up.
(add-hook' after-init-hook 'bm-repository-load)
 
;; Restoring bookmarks when on file find.
(add-hook 'find-file-hooks 'bm-buffer-restore)
 
;; Saving bookmark data on killing a buffer
(add-hook 'kill-buffer-hook 'bm-buffer-save)
 
;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when emacs is killed, so we
;; must save all bookmarks first.
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))


(provide 'programming-setup)
