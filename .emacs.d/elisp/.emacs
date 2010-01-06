;Time-stamp: <2009-12-31 22:15:59 stm>

;;--------------------------------------------------
;;  Load Paths
;;--------------------------------------------------

( add-to-list 'load-path "~/.emacs.d/elisp" )
( add-to-list 'load-path "~/.emacs.d/elisp/haskell-mode-2.4" )
( add-to-list 'load-path "~/.emacs.d/elisp/settings" )
( add-to-list 'load-path "~/.emacs.d/elisp/doxygen" )
( add-to-list 'load-path "~/.emacs.d/elisp/color-theme" )
( add-to-list 'load-path "~/.emacs.d/elisp/java-add-on" )

;org mode setup
( add-to-list 'load-path "~/.org/")

;; -------------------------------------------------
;; Variables
;; -------------------------------------------------
(defvar my-customize-file "~/.emacs.d/settings/custom.el")
(defvar autosave-dir (concat "~/tmp/backups/"))
(defvar backup-dir (concat "~/tmp/backups/"))


;;--------------------
;; Looks 
;;--------------------

;; no toolbar, no scrollbar, no menubar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; stop cursor from blinking
(if (fboundp 'blink-cursor-mode) (blink-cursor-mode 0))

;; show time on status bar
(setq display-time-format "%R %d-%m-%y")
(display-time)

;; Turn on column numbering in status line
(column-number-mode t)

;; color themes
(require 'color-theme)
(color-theme-initialize)

;; color-themes that are good for me:
(setq stm-color-theme 'color-theme-clarity)
;; (setq stm-color-theme 'color-theme-billw)
;; (setq stm-color-theme 'color-theme-emacs-nw)
;; (setq stm-color-theme 'color-theme-oswald)
;; (setq stm-color-theme 'color-theme-parus)
;; (setq stm-color-theme 'color-theme-pok-wob)
;; (setq stm-color-theme 'color-theme-taming-mr-arneson)
;; (setq stm-color-theme 'color-theme-tty-dark)

;; vertical and horisontal lines for easier navigation:
(require 'vline)
(require 'hl-line)
; ... and set colors:
(set-face-background 'hl-line "grey10")
(set-face-background 'vline "grey10")

;(setq stm-print-theme 'color-theme-high-contrast)

(funcall stm-color-theme)

(show-paren-mode t)

;; line-numbering
(require 'linum)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

(require 'notmuch)

; org-mode setup
( load-file ".org/org.emacs" )

;;--------------------------------------------------
;;  Key bindings
;;--------------------------------------------------

(require 'keybindings)
(my-keybindings)

;;--------------------------------------------------

;; -----------------------------------------------------
;; Hooks
;; -----------------------------------------------------

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

;;redo - Handy little redo function
;(require 'redo)

;; Uniquify buffer names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; mode for restructured text
(require 'rst)

;; programming snippets mode
(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet/snippets")

;; my functions
(load-library "functions")

;; mutt mode, for mutt...
(require 'mutt)

(setq auto-mode-alist
      (append auto-mode-alist
              '(("\\.[hg]s$"  . haskell-mode)
                ("\\.hi$"     . haskell-mode)
                ("\\.l[hg]s$" . literate-haskell-mode))))

(autoload 'haskell-mode "haskell-mode"
  "Major mode for editing Haskell scripts." t)
(autoload 'literate-haskell-mode "haskell-mode"
  "Major mode for editing literate Haskell scripts." t)

(require 'doxymacs)

; wiki-twiki markup mode
(require 'erin)

(require 'lua-mode)

;; -----------------------------------------------------
;; Emacs behaviour
;; -----------------------------------------------------

;; make del and insertions overwrite a selected region
(require 'delsel)
(delete-selection-mode t)

;; Moves mouse pointer to upper right corner, if the cursor is in the vicinity
(mouse-avoidance-mode (quote exile))

;; make the y or n suffice for a yes or no question
(fset 'yes-or-no-p 'y-or-n-p)

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

;; Visible bell instead of beeping hell
(setq visible-bell t)

;; This is to not display the initial message.
(setq inhibit-startup-message t)

;; and scratch should be scratch
(setq initial-scratch-message "" )

;; Scroll step - how much the screen scrolls up and down.
(setq-default scroll-step 1)
(setq-default scroll-conservatively 1000)

;;always follow symlinks
(setq vc-follow-symlinks t)

;; Put autosave files (ie #foo#) in one place, *not*
;; scattered all over the file system!
(make-directory autosave-dir t)
(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))
(defun make-auto-save-file-name ()
  (concat autosave-dir
          (if buffer-file-name
              (concat "#" (file-name-nondirectory buffer-file-name) "#")
            (expand-file-name
             (concat "#%" (buffer-name) "#")))))

;; Put backup files (ie foo~) in one place too. (The
;; backup-directory-alist list contains regexp=>directory mappings;
;; filenames matching a regexp are backed up in the corresponding
;; directory. Emacs will mkdir it if necessary.)
(setq backup-directory-alist (list (cons "." backup-dir)))

;; displays contents of the kill-ring in a separate buffer
(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)

;; instead of auto-reverting - which works somewhat against
;; expectations (which in this case would be my expectations of using
;; a very shiny little silver spoon as sledge-hammer) - emacs comes
;; with userlock, which does exactly what I want (making big holes in
;; stuff)
(load "userlock")


;; ---------------------------------------------------------
;; programming specifices
;; ---------------------------------------------------------

;;;;;;;;;
;; Python

(setq python-mode-hook
      '(lambda () 
         (progn
           (set-variable 'py-python-command "/usr/bin/ipython")
           (set-variable 'py-indent-offset 4)
           (set-variable 'py-smart-indentation nil)
           (set-variable 'indent-tabs-mode nil)
           (set-variable 'yas/minor-mode t)
           )))

;; Formatting Python code for Transifex.
(defun local/python-mode-options ()
  (setq fill-column 72              ;text wrap column
        python-indent 4             ;use 4-column indentation for Python
        indent-tabs-mode nil        ;use only SPC for indentation
        next-line-add-newlines nil)) ;don't add newlines at end-of-file

(eval-after-load "python"
  '(add-hook 'python-mode 'local/python-mode-options))

;; Highlight long lines on python mode in order to comply with pep 8
(font-lock-add-keywords
 'python-mode
 '(("^[^\n]\\{80\\}\\(.*\\)$"
    1 font-lock-warning-face prepend)))

(autoload 'python-mode "python-mode" "Python Mode." t)

(add-to-list 'interpreter-mode-alist '("ipython" . python-mode))

;;;;;;;
;; Java

(require 'java-add-on)

(add-hook 'java-mode-hook 'java-add-on-keymap)
(add-hook 'java-mode-hook 'java-add-on-indent)
