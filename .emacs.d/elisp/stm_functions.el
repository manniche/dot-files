(defun nuke-all-buffers ()
  "Kill all buffers, leaving *scratch* only."
  (interactive)
  (mapc (lambda (x) (kill-buffer x)) (buffer-list)) (delete-other-windows))

;; define the function to kill the characters from the cursor 
;; to the beginning of the current line
(defun backward-kill-line ()
  "Kill chars backward until encountering the end of a line."
  (interactive)
  (kill-line 0))


;; (defun c-newline-and-perhaps-comment (&optional soft)
;;   "Insert a newline and continue commenting if inside a C style comment.
;; This function usually inserts a newline character.  However it has
;; several other actions;

;; If point is within a one line comment /* ... */ then point is moved to the
;; next line of code .

;; If point is directly after /* then a multi-line comment block is written
;; and point placed on the first line.

;; If point is within a multi-line comment, then a newline starting with a
;; '*' is added at the correct indentation.

;; If point is after an empty line, any remaining white space is removed.

;; If c-auto-newline is on, then the correct indentation is placed on the next
;; line regardless.

;; The inserted newline is marked hard if `use-hard-newlines' is true,
;; unless optional argument SOFT is non-nil."
;;   (interactive)
;;   (let ((auto-fill-function nil))
;;     (save-match-data
;;       (cond (;;
;;         ;; Inside a one line comment?
;;         ;;
;;         (and (save-excursion
;;             (end-of-line)
;;             (let ((eol-pos (point)))
;;               (beginning-of-line)
;;               (re-search-forward "/\\*.*\\*/" eol-pos t)))
;;           (>= (point) (match-beginning 0))
;;           (<= (point) (match-end 0)))
;;         ;;
;;         ;; Then goto next line.
;;         ;;
;;         (end-of-line)
;;         (if soft (insert ?\n) (newline))
;;         (if c-auto-newline
;;          (indent-according-to-mode)))
;;         (;;
;;         ;; Inside a block comment?
;;         ;;
;;         (save-excursion
;;           (and (re-search-backward "/\\*\\|\\*/" 0 t)
;;             (string= "/*" (buffer-substring (match-beginning 0)
;;                             (match-end 0)))))
;;         ;;
;;         ;; Check if we just wrote "/*", if so build a comment block.
;;         ;;
;;         (if (save-excursion
;;           (end-of-line)
;;           (re-search-backward "/\\*\\([^ \t]*\\)\\(.*\\)"
;;                       (save-excursion (beginning-of-line)
;;                               (point)) t))
;;          (let ((col (save-excursion (goto-char (match-beginning 0))
;;                         (current-column)))
;;               (start (buffer-substring (match-beginning 1)
;;                         (match-end 1)))
;;               (text (buffer-substring (match-beginning 2)
;;                           (match-end 2))))
;;           (if (/= (length text) 0)
;;               (delete-region (match-beginning 2) (match-end 2))
;;             (setq text " "))
;;           (if soft (insert ?\n) (newline))
;;           (indent-to-column col)
;;           (insert " *" text)
;;           (if soft (insert ?\n) (newline))
;;           (indent-to-column col)
;;           (if (/= (length start) 1)
;;               (insert " "))
;;           ;;
;;           ;; Handle JavaDoc convention correctly. (ie. /** ... */)
;;           ;;
;;           (if (string-equal start "*")
;;               (insert " ")
;;             (insert start))
;;           (insert "*/")
;;           (previous-line 1)
;;           (end-of-line))
;;           ;;
;;           ;; Otherwise continue the comment block.
;;           ;;
;;           (if soft (insert ?\n) (newline))
;;           (indent-according-to-mode)
;;           (insert "*")
;;           (indent-relative)))
;;         (;;
;;         ;; After an empty line?
;;         ;;
;;         (save-excursion
;;           (beginning-of-line)
;;           (looking-at "[    ]+$"))
;;         (delete-region
;;           (match-beginning 0)
;;           (match-end 0))
;;         (if soft (insert ?\n) (newline))
;;         (if c-auto-newline
;;          (indent-according-to-mode)))
;;         (;;
;;         ;; Otherwise just do a normal newline.
;;         ;;
;;         (if soft (insert ?\n) (newline))
;;         (if c-auto-newline
;;          (indent-according-to-mode)))
;;         ))))


(provide 'stm_functions)
