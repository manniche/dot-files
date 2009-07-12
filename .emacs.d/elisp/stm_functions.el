;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Jabber settings

;(setq jabber-message-alert-same-buffer nil)


(setq jabber-account-list '(
                            ("stm"
                              (:password . nil) or (:password . "m4xHorkheimer")
                              (:network-server . "kelut.dbc.dk")
                              (:port . 5222)
                            )
                            )
)

(setq jabber-xosd-display-time 5)
(defun jabber-xosd-display-message (message)
  "Displays MESSAGE through the xosd"
  (let ((process-connection-type nil))
    (start-process "jabber-xosd" nil "osd_cat" "-p" "bottom" "-A" "center" "-f" "-*-courier-*-*-*-*-30" "-d" (number-to-string jabber-xosd-display-time))
    (process-send-string "jabber-xosd" message)
    (process-send-eof "jabber-xosd")))

(defun jabber-message-xosd (text a)
  (jabber-xosd-display-message "New message."))

;(add-hook 'jabber-activity-update-hook 'jabber-activity-ion3-modeline-update)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ion3 interaction

;; (defun ion3-inform (slot message &optional hint)
;;   "Send a message to the ion3-statusbar's slot.
;; hint can be: normal, important, or critical."
;;   (call-process "ionflux" nil 0 nil "-e"
;;                 (format "mod_statusbar.inform('%s', '%s');
;;                          mod_statusbar.inform('%s_hint', '%s');
;;                          mod_statusbar.update()" 
;;                         slot message slot hint)))

(defun java-alphabetize-imports ()
  "Alphabetize the import lines in a java file"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (if (re-search-forward "^import" nil t )
        (progn (beginning-of-line)
               (re-search-backward "[ \t]" nil t )
               (next-line)
               (beginning-of-line)
               (push-mark)
               (while (re-search-forward "^import" nil t ) )
               (end-of-line)
               (delete-blank-lines)
               (shell-command-on-region (mark)
                                        (point) "~/.emacs.d/python/alphabetize-import-lines.py" nil t nil t)
               (message "alphabetized import lines" ))
      (message "No import lines in this file!"))))  

;den kalder så en python fil der er vedhæftet.  to mere generelle
;udgaver af python kaldet. Den første definere interactive r - den
;skal have to argumenter og kan gives en region (man kan markere
;noget og kalde funktionen ).

(defun my-process-region (startPos endPos)
  "Do some text processing on region. This command calls the external script"
  (interactive "r")
  (let (scriptName) (setq scriptName "/home/shm/test.py")
       (shell-command-on-region startPos endPos scriptName nil t nil t) ))

(defun my-process-region-with (startPos endPos script)
  "Do some text processing on region. This command calls the external script"
  (interactive)
  (shell-command-on-region startPos endPos script nil t nil t) )

(defun nuke-all-buffers ()
"Kill all buffers, leaving *scratch* only."
(interactive)
(mapcar (lambda (x) (kill-buffer x)) (buffer-list)) (delete-other-windows))

(defun c-newline-and-perhaps-comment (&optional soft)
  "Insert a newline and continue commenting if inside a C style comment.
This function usually inserts a newline character.  However it has
several other actions;

If point is within a one line comment /* ... */ then point is moved to the
next line of code .

If point is directly after /* then a multi-line comment block is written
and point placed on the first line.

If point is within a multi-line comment, then a newline starting with a
'*' is added at the correct indentation.

If point is after an empty line, any remaining white space is removed.

If c-auto-newline is on, then the correct indentation is placed on the next
line regardless.

The inserted newline is marked hard if `use-hard-newlines' is true,
unless optional argument SOFT is non-nil."
  (interactive)
  (let ((auto-fill-function nil))
    (save-match-data
      (cond (;;
        ;; Inside a one line comment?
        ;;
        (and (save-excursion
            (end-of-line)
            (let ((eol-pos (point)))
              (beginning-of-line)
              (re-search-forward "/\\*.*\\*/" eol-pos t)))
          (>= (point) (match-beginning 0))
          (<= (point) (match-end 0)))
        ;;
        ;; Then goto next line.
        ;;
        (end-of-line)
        (if soft (insert ?\n) (newline))
        (if c-auto-newline
         (indent-according-to-mode)))
        (;;
        ;; Inside a block comment?
        ;;
        (save-excursion
          (and (re-search-backward "/\\*\\|\\*/" 0 t)
            (string= "/*" (buffer-substring (match-beginning 0)
                            (match-end 0)))))
        ;;
        ;; Check if we just wrote "/*", if so build a comment block.
        ;;
        (if (save-excursion
          (end-of-line)
          (re-search-backward "/\\*\\([^ \t]*\\)\\(.*\\)"
                      (save-excursion (beginning-of-line)
                              (point)) t))
         (let ((col (save-excursion (goto-char (match-beginning 0))
                        (current-column)))
              (start (buffer-substring (match-beginning 1)
                        (match-end 1)))
              (text (buffer-substring (match-beginning 2)
                          (match-end 2))))
          (if (/= (length text) 0)
              (delete-region (match-beginning 2) (match-end 2))
            (setq text " "))
          (if soft (insert ?\n) (newline))
          (indent-to-column col)
          (insert " *" text)
          (if soft (insert ?\n) (newline))
          (indent-to-column col)
          (if (/= (length start) 1)
              (insert " "))
          ;;
          ;; Handle JavaDoc convention correctly. (ie. /** ... */)
          ;;
          (if (string-equal start "*")
              (insert " ")
            (insert start))
          (insert "*/")
          (previous-line 1)
          (end-of-line))
          ;;
          ;; Otherwise continue the comment block.
          ;;
          (if soft (insert ?\n) (newline))
          (indent-according-to-mode)
          (insert "*")
          (indent-relative)))
        (;;
        ;; After an empty line?
        ;;
        (save-excursion
          (beginning-of-line)
          (looking-at "[    ]+$"))
        (delete-region
          (match-beginning 0)
          (match-end 0))
        (if soft (insert ?\n) (newline))
        (if c-auto-newline
         (indent-according-to-mode)))
        (;;
        ;; Otherwise just do a normal newline.
        ;;
        (if soft (insert ?\n) (newline))
        (if c-auto-newline
         (indent-according-to-mode)))
        ))))


(provide 'stm_functions)


;; sandbox below

(defun java-doc-gen ()
  (interactive)
  "Running this function on the line above a function declaration in java produces some boilerplate documentation on the function."
  (let ((beg (point)))
    (re-search-forward "^\\(public\\|private\\|protected\\)\\(\s+[a-z]+\\)+\\(\(\\(\s*[a-z]*[,]?\\)*\)\\)\\(\s?throws\\)?\s?\\(\\w+Exception[,]?\s?\\)*\\(\{$\\)" nil t)
    (goto-char beg)
    (insert (concat "/**\n* " ;(if (/= 0 (length (match-string 4)))
                          (concat "\@throws " 
                                  (loop for i in (match-string 6) 
                                          ;(match-string 6)
                                        collect(insert (concat "hej" (match-string i)))
                                        )
                                          "\n**/"
                                          )
                          )
            )
    
    )
  )

;;testdata
;; public static void doGet( String collar, int two) throws IOException{

;; }

;; private void getDo( Callable sir ){

;; }


;; protected String stringDo( ) throws IOException, RemoteException{

;; }
