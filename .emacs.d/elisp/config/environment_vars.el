;; This file defines variable related to all emacs instances.

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


(defvar username ( getenv "USER" ) )
(defvar hostname ( substring ( system-name ) 0 ( string-match "\\." ( system-name ) ) ) )

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

;;always follow symlinks
(setq vc-follow-symlinks t)


(provide 'environment_vars)