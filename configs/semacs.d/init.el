(add-to-list 'load-path "~/.semacs.d/elisp/")
(add-to-list 'load-path "~/.semacs.d/elisp/jabber/")
(add-to-list 'load-path "~/.semacs.d/elisp/fsm")

(require 'ido)
(ido-mode t)

(require 'delsel)
(delete-selection-mode t)

(require 'vline)

;;; Mutt/email (post-mode)
(require 'mutt)

(require 'jabber)

(defadvice server-process-filter (after post-mode-message first activate)
   "If the buffer is in post mode, overwrite the server-edit
   message with a post-save-current-buffer-and-exit message."
   (if (eq major-mode 'post-mode)
       (message
        (substitute-command-keys "Type \\[describe-mode] for help composing; \\[post-save-current-buffer-and-exit] when done.")))
   (if (eq major-mode 'mail-mode)
       (message
        (substitute-command-keys "Type \\[describe-mode] for help composing; \\[post-save-current-buffer-and-exit] when done."))))
; This is also needed to see the magic message.  Set to a higher
; number if you have a faster computer or read slower than me.
'(font-lock-verbose 1000)
; (setq server-temp-file-regexp "mutt-")
(add-hook 'server-switch-hook
        (function (lambda()
                    (cond ((string-match "Post" mode-name)
                           (post-goto-body))))))


;; functions 
(defun insert-timestamp ()
  "Inserts time-stamp in top of file, commented"
  (interactive)
  (goto-char (point-min))
  (insert (concat comment-start "Time-stamp: <>\n"))
)

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))


(defun copy-line (&optional arg)
      "Save current line into Kill-Ring without mark the line "
       (interactive "P")
       (let ((beg (line-beginning-position)) 
     	(end (line-end-position arg)))
         (copy-region-as-kill beg end))
     )
(defun indent-current-region-by (num-spaces)
   (indent-rigidly (region-beginning) (region-end) num-spaces)
) 

(defun dedent-current-region ()
   (interactive)
   (indent-current-region-by (- 1))
)
(defun indent-current-region ()
   (interactive)
   (indent-current-region-by (+ 1))
)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variable settings

;;always follow symlinks
(setq vc-follow-symlinks t)

(defvar autosave-dir (concat "~/tmp/backups/"))
(defvar backup-dir (concat "~/tmp/backups/"))

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

;; reduce number of standard keypresses for Steen
(fset 'yes-or-no-p 'y-or-n-p)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

;(set-face-background 'hl-line "grey10")
;(set-face-background 'vline "grey10")
(setq auto-insert-directory "~/tmp/emacs/ido-insert")
(setq ido-save-directory-list-file "~/tmp/emacs/ido.last")

;; no startup screen
(setq inhibit-startup-screen t)

;; and scratch should be scratch
(setq initial-scratch-message "" )
(setq history-delete-duplicates t)
(setq history-length 100)
(setq icomplete-mode t)
(setq ido-everywhere t)
(setq initial-major-mode (quote text-mode))
(setq visible-bell t)

;; use spaces when indenting
(setq-default indent-tabs-mode nil)
; no toolbar, no scrollbar, no menubar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key bindings

;hurtig switch mellem buffers i en frame
(global-set-key [s-left] 'previous-buffer)
(global-set-key [s-right] 'next-buffer)

(global-set-key "\M-o" 'other-window)

(global-set-key "\M-r" 'revert-buffer)
;; mark-whole-buffer bruges tit ( brug i stedet C-x h)
(global-set-key "\M-a" 'mark-whole-buffer)

(global-set-key "\M-n" 'linum-mode)

(global-set-key "\M-v" 'vline-mode)

(global-set-key "\M-h" 'hl-line-mode)

(global-set-key [M-left] 'dedent-current-region)
(global-set-key [M-right] 'indent-current-region)

;; undo gør jeg mig meget i
(global-set-key [M-backspace] 'undo-only)

;; inserts timestamp
(global-set-key "\C-c\ t" 'insert-timestamp)

;kill-copy line
(global-set-key "\C-c\ l" 'copy-line)

;; un-bindings:
;;;;;;;;;;;;;;;

;; insert: nej, hellere yank
(global-unset-key [insert])
(global-set-key [insert] 'yank)

;; jeg rammer af en eller anden grund hele tiden denne tastkombo...
(global-unset-key (kbd "C-o"))
