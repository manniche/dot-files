;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Navigation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; used for "scrolling in place" and "scroll other window" and mouse scroll
(defun scroll-other-window-up-1 ()
  (interactive)
  (scroll-other-window 1))

(defun scroll-other-window-down-1 ()
  (interactive)
  (scroll-other-window -1))

(defun scroll-up-1 ()
  (interactive)
  (scroll-up 1))

(defun scroll-down-1 ()
  (interactive)
  (scroll-down 1))

;; transpose
(defun move-line-down ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines 1))
    (forward-line)
    (move-to-column col)))

(defun move-line-up ()
  (interactive)
  (let ((col (current-column)))
    (save-excursion
      (forward-line)
      (transpose-lines -1))
    (move-to-column col)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Frames
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; resize frames with one line
(defun shrink-window-1 ()
  (interactive)
  (shrink-window 1))
(defun grow-window-1 ()
  (interactive)
  (shrink-window (- 0 1)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text Manipulation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))

;; Like C-k, only kills from line start to point.
(defun kill-prev ()
  (interactive)
  (set-mark-command nil)
  (beginning-of-line)
  (kill-region (point) (mark)))

(defun copy-line (&optional arg)
  "Save current line into Kill-Ring without marking the line "
  (interactive "P")
  (let ((beg (line-beginning-position)) 
        (end (line-end-position arg)))
    (copy-region-as-kill beg end))
  )

(defun my_all()
  "make all buffer"
  (interactive)
  (call-interactively 'all))


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


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Viewing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; Toggles between line wrapping in the current buffer.
(defun toggle-line-wrapping ()
  "Toggles between line wrapping in the current buffer."
  (interactive)
  (if (eq truncate-lines nil)
      (progn
        (setq truncate-lines t)
        (redraw-display)
        (message "Setting truncate-lines to t"))
    (setq truncate-lines nil)
    (redraw-display)
    (message "Setting truncate-lines to nil"))
  )


;; Split a window in two coloums, two rows
(defun split-window-in-four ()
  "Splits a window in two columns, two rows"
  (interactive)
  (split-window-horizontally)
  (split-window-vertically)
  (other-window 2)
  (split-window-vertically)
  (other-window -2)
)

(defun toggle-window-split ()
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
	     (next-win-buffer (window-buffer (next-window)))
	     (this-win-edges (window-edges (selected-window)))
	     (next-win-edges (window-edges (next-window)))
	     (this-win-2nd (not (and (<= (car this-win-edges)
					 (car next-win-edges))
				     (<= (cadr this-win-edges)
					 (cadr next-win-edges)))))
	     (splitter
	      (if (= (car this-win-edges)
		     (car (window-edges (next-window))))
		  'split-window-horizontally
		'split-window-vertically)))
	(delete-other-windows)
	(let ((first-win (selected-window)))
	  (funcall splitter)
	  (if this-win-2nd (other-window 1))
	  (set-window-buffer (selected-window) this-win-buffer)
	  (set-window-buffer (next-window) next-win-buffer)
	  (select-window first-win)
	  (if this-win-2nd (other-window 1))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Printing
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defvar stm-color-theme 'color-theme-comidia)
(defvar stm-print-theme 'color-theme-high-contrast)
(defvar stm-highlight "gray8" )

(defun print-to-ps ()
  (let ((tmpfile (make-temp-file "emacs-printing_")))
    (funcall stm-print-theme)
    (ps-spool-buffer-with-faces)
    (switch-to-buffer "*PostScript*")
    (write-file tmpfile)
    (kill-buffer (current-buffer))
    (funcall stm-color-theme)
    tmpfile))

(defun print-to-pdf ()
  (interactive)
  (let ((pdf-file) (tmpfile (print-to-ps)))
    (setq pdf-file (concat default-directory (car (split-string (buffer-name) "\\.")) ".pdf"))
    (call-process "ps2pdf14" nil nil nil tmpfile pdf-file)
    (shell-command (concat "rm " tmpfile))
    (message "saved output to: %s" pdf-file)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Elisp compilation
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Byte compile elisp files after saving
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (add-hook 'after-save-hook
                       '(lambda ()
                          (byte-compile-file buffer-file-name))
                       nil t)))

;; Added Automatic Reloading Of .Emacs Changes!
(add-hook 'after-save-hook 'my-aftershave-function)
(defun my-aftershave-function ()
  (and (equal (expand-file-name "~/.emacs") buffer-file-name)
       (load-file (expand-file-name "~/.emacs"))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Dictionary functions
(defun change-to-dansk ()
  (interactive)
  (ispell-change-dictionary "dansk"))

(defun change-to-american ()
  (interactive)
  (ispell-change-dictionary "american"))


;; insert date into buffer
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%eT%H:%M:%S%z" )))

;; insert date into buffer
(defun insert-date-alt ()
  "Insert alternative date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%e %H:%M" )))


;; does a general java.sun.com search, but mostly hits the api
(defun search-java-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url (concat "http://search.sun.com/search/main/index.jsp?qt=" search))))

;; docs.python.org
(defun search-python-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url (concat "http://www.google.com/search?q=" search"&domains=docs.python.org&sitesearch=docs.python.org&sourceid=google-search&submit=submit"))))


;;searches on emacswiki.org
(defun search-elisp-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url (concat "http://www.google.com/search?q=" search"&domains=www.emacswiki.org&sitesearch=www.emacswiki.org&sourceid=google-search&submit=submit"))))

;;lookup word-at-point on merriam-webster
(defun search-word-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url (concat "http://www.merriam-webster.com/dictionary/" search )))
)

;; registers search-functions with major modes
(defun search-expr-at-point ()
  (interactive)
  (cond 
   ((eq major-mode 'java-mode) (search-java-at-point))
   ((eq major-mode 'python-mode) (search-python-at-point))
   ((eq major-mode 'emacs-lisp-mode) (search-elisp-at-point))
   )
)

;;;;;; Mutt insert quotes

(defun call-python-str (program &rest args)
  "Calls python file program, with args, and returns answer in string"
  (let ( (curbuf (current-buffer)) (tmp-buf  (generate-new-buffer "python-answer")) (answer) (cmd))
    (setq cmd  (cons 'call-process (cons "python" (cons nil (cons tmp-buf (cons nil (cons program args)))))))
    (eval cmd)
    (set-buffer tmp-buf)
    (copy-region-as-kill (point-min) (point-max))
    (setq answer (current-kill 0))
    (set-buffer curbuf)
    (kill-buffer tmp-buf)
    answer))

(defun insert-address ( arg )
;;  (interactive "s" )
  (insert (call-python-str "/home/steman/.gensig/gensig.py" arg))
)

(defun insert-address-infopaq ()
  (interactive)
  (insert-address "infopaq" )
)

(defun insert-address-manniche ()
  (interactive)
  (insert-address "manniche" )
)

(defun insert-quote ()
  (interactive)
  (insert-address "quote" )
)


(defun sudo-file ()
  "Re-open the current buffer's file with sudo"
  (interactive)
  (let ((p (point)))
    (find-alternate-file
     (concat "/sudo::" (buffer-file-name)))
    (goto-char p)))

(fset 'replace-ctrlms
   [escape ?< escape ?% ?\C-q ?\C-m return return ?!])
(global-set-key "\C-cm" 'replace-ctrlms)

(provide 'my_functions)
