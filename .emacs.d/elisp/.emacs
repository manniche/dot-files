;Time-stamp: <2011-02-18 13:28:38 steman>

;;--------------------------------------------------
;;  Load Paths
;;--------------------------------------------------

( add-to-list 'load-path "~/.emacs.d/elisp" )
( add-to-list 'load-path "~/.emacs.d/elisp/config" )
( add-to-list 'load-path "~/.emacs.d/elisp/color-theme" )
( add-to-list 'load-path "~/.emacs.d/elisp/project-mode" )
( add-to-list 'load-path "~/.emacs.d/elisp/grails-mode" )
( add-to-list 'load-path "~/.emacs.d/elisp/clojure-mode" )
;org mode setup
( add-to-list 'load-path "~/.org/")

( setq org-directory "~/.org" )
( setq org-mobile-inbox-for-pull "~/.org/iphone.org" )
( setq org-mobile-directory "~/Dropbox/MobileOrg" )

;; initialization files

(require 'init)


;; -------------------------------------------------
;; Variables
;; -------------------------------------------------

(require 'environment_vars)
;;--------------------
;; Looks 
;;--------------------

(require 'ui)

;;--------------------------------------------------
;;  Key bindings
;;--------------------------------------------------

(require 'keybindings)
(my-keybindings)

;; -------------------------------------------------
;; Programming modes
;; -------------------------------------------------

;(require 'emacs-clojure)
;(require 'emacs-java)

;; mode for restructured text
(autoload 'rst "rst" "Major mode for editing rst documents." t)
(add-to-list 'auto-mode-alist '("\\.rst$" . rst))
(add-to-list 'auto-mode-alist '("\\.[markdown]$" . rst))
;; (require 'rst)
;; (setq auto-mode-alist
;;       (append auto-mode-alist
;;               '(("\\.[markdown]$"  . rst-mode))
;;               )
;;       )

(setq
   ;; no background face for rst headlines
   rst-level-face-base-color nil
   )

(autoload 'lua-mode "lua-mode" "Major mode for editing lua code." t)
(add-to-list 'auto-mode-alist '("\\.lua$" . lua-mode))

(autoload 'clojure-mode "clojure-mode" "Major mode for editing clojure code." t)
(add-to-list 'auto-mode-alist '("\\.clj$" . clojure-mode))

(require 'grails-mode)
;(setq grails-mode t)
;(setq project-mode t)
(add-to-list 'auto-mode-alist '("\.gsp$" . nxml-mode)) ; Use whatever mode you want for views.
(project-load-all) ; Loads all saved projects. Recommended, but not required.

(autoload 'groovy-mode "groovy-mode" "Major mode for editing groovy code." t)
(add-to-list 'auto-mode-alist '("\\.groovy$" . groovy-mode))

;; -----------------------------------------------------
;; Modes, packages and configurations relative to them
;; -----------------------------------------------------

;; http://www.emacswiki.org/emacs/Edit_with_Emacs
;(require 'edit-server)
;(edit-server-start)
  

;; emacs package system
;(require 'package)

;; bookmarks
(require 'bm)
(require 'bm-ext)
;;bookmarks only places mark at the left
(setq bm-highlight-style (quote bm-highlight-only-fringe))
;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)
 
;; number the windows (yes, frames) for easy access
(autoload 'window-number-meta-mode "window-number" t)
(window-number-meta-mode t)

;; ido; interactively do things with buffers and files.
(require 'ido)
(ido-mode t)
; improving ido-mode
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)

;; my functions
(require 'functions)

; wiki-twiki markup mode
(require 'erin)

;; custom templates for various programming modes
(require 'templates)

;; sanitize [x/ht]ml
(autoload 'tidy "tidy-mode" "mode for sanitizing (x)html" t)


;; Session persistance
(require 'desktop)
(setq desktop-dir "~/.emacs.d/desktop")
(desktop-save-mode 1)

;; -----------------------------------------------------
;; Emacs behaviour
;; -----------------------------------------------------

;; make del and insertions overwrite a selected region
(require 'delsel)
(delete-selection-mode t)

;; Moves mouse pointer to upper right corner, if the cursor is in the vicinity
(mouse-avoidance-mode (quote exile))

;; Scroll step - how much the screen scrolls up and down.
(setq-default scroll-step 1)
(setq-default scroll-conservatively 1000)

;; displays contents of the kill-ring in a separate buffer
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; instead of auto-reverting - which works somewhat against
;; expectations (which in this case would be my expectations of using
;; a very shiny little silver spoon as sledge-hammer) - emacs comes
;; with userlock, which does exactly what I want (making big holes in
;; stuff)
(load "userlock")


;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
;; (when
;;     (load
;;      (expand-file-name "~/.emacs.d/elpa/package.el"))
;;   (package-initialize))

;; -------------------------------------------------
;; Hooks
;; -------------------------------------------------

;; byte-compile elisp after save
(add-hook 'after-save-hook 'my-aftershave-function)

; Update time stamp hook on save
(add-hook 'write-file-hooks 'time-stamp)
; ...but only within the first 10 lines
(setq time-stamp-line-limit 10)

;;;;;;;;;;;;;;;;
;; bm-mode hooks
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


(add-hook 'java-mode-user-hook
          '(lambda ()
             (outline-minor-mode)
             (setq outline-regexp " *\\(private \\|public \\|protected \\|private class\\|public class\\)")
             (hide-sublevels 1)))


;; Desktop hook. Automatically save desktop file on C-x C-s
;;(add-hook 'auto-save-hook (lambda () (desktop-save-in-desktop-dir)))


;; Custom variables

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(nxhtml-autoload-web nil t)
 '(rst-level-face-base-color "nil"))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "Grey15" :foreground "Grey" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 90 :width normal :foundry "unknown" :family "DejaVu Sans Mono")))))
