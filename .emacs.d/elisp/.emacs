;Time-stamp: <2010-04-01 17:49:17 stm>

;;--------------------------------------------------
;;  Load Paths
;;--------------------------------------------------

( add-to-list 'load-path "~/.emacs.d/elisp" )
;( add-to-list 'load-path "~/.emacs.d/elisp/haskell-mode-2.4" )
( add-to-list 'load-path "~/.emacs.d/elisp/config" )
( add-to-list 'load-path "~/.emacs.d/elisp/color-theme" )
( add-to-list 'load-path "~/.emacs.d/elpa" )

;org mode setup
( add-to-list 'load-path "~/.org/")

;; initialization files

(require 'init)


;; -------------------------------------------------
;; Variables
;; -------------------------------------------------

(setq
   ;; no background face for rst headlines
   rst-level-face-base-color nil
   )

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

(load-library "clojure-emacs")

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

;; -----------------------------------------------------
;; Modes, packages and configurations relative to them
;; -----------------------------------------------------

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

;; mode for restructured text
(require 'rst)
(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[markdown]$"  . rst-mode))
              )
      )

;; my functions
(require 'functions)

; wiki-twiki markup mode
(require 'erin)

;; custom templates for various programming modes
(require 'templates)

;; sanitize [x/ht]ml
(autoload 'tidy "tidy-mode" "mode for sanitizing (x)html" t)

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
