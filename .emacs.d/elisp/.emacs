;Time-stamp: <2009-06-04 14:03:14 stm>

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; initialize load-paths
(add-to-list 'load-path "~/.emacs.d/elisp")
(add-to-list 'load-path "~/.emacs.d/elisp/java")
(add-to-list 'load-path "~/.emacs.d/elisp/color-theme")
(add-to-list 'load-path "~/.emacs.d/elisp/yasnippet")
(add-to-list 'load-path "~/.emacs.d/elisp/orgmode")
(add-to-list 'load-path "~/.emacs.d/elisp/jabber")
(add-to-list 'load-path "~/.emacs.d/elisp/doxygen")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; start the emacs server
(server-start)

;; load modes &c.
(require 'color-theme)
(color-theme-initialize)

; templates resides in ~/.emacs.d/elisp/templates.el
(require 'templates)

(require 'stm_functions)

(require 'ido)
;(autoload 'ido "ido" "Interactive do mode" t)
(ido-mode t)

(require 'rst)
;(autoload 'rst "rst" "ReSTructured text mode" t)  ;; or (load "rst")

(require 'yasnippet)
(yas/initialize)
(yas/load-directory "~/.emacs.d/elisp/yasnippet/snippets")

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(require 'erin)

;(require 'java-mode-indent-annotations)
(load-library "java-add-on")
(require 'psvn)

;(require 'jabber)
;(require 'jabber-autoloads)

(autoload 'lua-mode "lua-mode" "Lua editing mode." t)

;; make del and insertions overwrite a selected region
(require 'delsel)
(delete-selection-mode t)
;(setq delete-selection-mode 't)

(autoload 'org-install "org-mode" "org mode" t)

(require 'vline)
(require 'hl-line)

(require 'doxymacs)

(require 'bm)
(require 'bm-ext)

;; number the windows (yes, frames) for easy access
(autoload 'window-number-meta-mode "window-number" t)
;; and enable it globally
(window-number-meta-mode t)

; for the mode-line, enable column-numbering
(column-number-mode t)

(require 'browse-kill-ring)
(browse-kill-ring-default-keybindings)



;; mode-list
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-to-list 'auto-mode-alist '("\\.xml\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsd\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.cs\\'"  . java-mode))
(add-to-list 'auto-mode-alist '("\\.rst\\'" . rst-mode))
(add-to-list 'auto-mode-alist '("\\.ipy\\'" . python-mode))
(add-to-list 'auto-mode-alist '("\\.py\\'"  . python-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-mode))
(add-to-list 'auto-mode-alist '(".mozilla/firefox/.*/itsalltext/wiki.dbc.dk.*\\.txt$" . erin-mode))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ui things
;(color-theme-deep-blue) ;; afslappet
;(color-theme-high-contrast) ;; nemlig det.
;(setq stm-color-theme 'color-theme-comidia)
(setq stm-print-theme 'color-theme-high-contrast)
;(setq stm-color-theme 'color-theme-colorful-obsolescence) ;;farver og striber!
(setq stm-color-theme 'color-theme-subtle-hacker)

(funcall stm-color-theme)

;; (setq stm-highlight "gray8")
;; (highlight-current-line-set-bg-color stm-highlight)

(show-paren-mode t)
;(set-frame-font "-unknown-DejaVu Sans Mono-bold-normal-normal-*-16-*-*-*-m-0-*-*")
;(set-frame-font "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;(set-face-font 'default "-bitstream-bitstream vera sans mono-medium-r-*-*-*-80-*-*-*-*-*-*")
;(set-face-font 'default "-adobe-courier-medium-r-normal--0-0-100-100-m-0-iso10646-1")
;(set-face-font 'default "-b&h-lucidatypewriter-medium-r-normal-sans-0-0-100-100-m-0-iso10646-1")
;(set-face-font 'default "-unknown-DejaVu Sans Mono-normal-normal-normal-*-14-*-*-*-m-0-iso10646-1")
;(set-face-font 'default "-*-lucidatypewriter-medium-*-*-*-16-*-*-*-*-*-*-*")
;(set-face-font 'default "-adobe-courier-medium-r-normal-*-16-100-*-*-*-*-iso10646-1")

(set-face-background 'hl-line "grey10")
(set-face-background 'vline "grey10")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hooks and functions ;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; This will be fun...
(global-auto-revert-mode 1)

;;;;;;;;
;; hooks
(add-hook 'after-save-hook 'my-aftershave-function)

;; see stm-functions.el
;(add-hook 'jabber-activity-update-hook 'jabber-message-xosd)
(add-hook 'jabber-alert-message-hook 'jabber-message-xosd)

; Time stamp hook on save
(add-hook 'write-file-hooks 'time-stamp)
; but only within the first 10 lines
(setq time-stamp-line-limit 10)

;;bm-mode hooks
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


;;;;;;;;;;;
;;functions
(defun my-aftershave-function ()
  (and (equal (expand-file-name "~/.emacs") buffer-file-name)
       (load-file (expand-file-name "~/.emacs"))))

(defun insert-timestamp ()
  "Inserts time-stamp in top of file, commented"
  (interactive)
  (goto-char (point-min))
  (insert (concat comment-start "Time-stamp: <>\n"))
)

;; Like C-k but from the end of line, cool
(defun backwards-kill-line () (interactive) (kill-region
                   (point) (progn (beginning-of-line) (point))))

;; resize frames with one line
(defun shrink-window-1 ()
  (interactive)
  (shrink-window 1))
(defun grow-window-1 ()
  (interactive)
  (shrink-window (- 0 1)))
(defun scroll-up-1 ()
  (interactive)
  (scroll-up 1))
(defun scroll-down-1 ()
  (interactive)
  (scroll-down 1))

(defun scroll-other-window-up-1 ()
  (interactive)
  (scroll-other-window -1))
(defun scroll-other-window-down-1 ()
  (interactive)
  (scroll-other-window 1))

(defun scroll-up-5 ()
  (interactive)
  (scroll-up 5))
(defun scroll-down-5 ()
  (interactive)
  (scroll-down 5))

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

;; does a general java.sun.com search, but mostly hits the api
(defun search-java-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url-firefox (concat "http://search.sun.com/search/main/index.jsp?qt=" search)
                        )
    )
)

;; docs.python.org
(defun search-python-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url-firefox (concat "http://www.google.com/search?q=" search"&domains=docs.python.org&sitesearch=docs.python.org&sourceid=google-search&submit=submit")
                        )
    )
)

;;searches on emacswiki.org
(defun search-elisp-at-point ()
  (interactive)
  (let ((search (thing-at-point 'word)))
    (browse-url-firefox (concat "http://www.google.com/search?q=" search"&domains=www.emacswiki.org&sitesearch=www.emacswiki.org&sourceid=google-search&submit=submit")
                        )
    )
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

;;--------------------------------------------------
;; Java
;;--------------------------------------------------


;; key bindings for java-add-on
(defun java-add-on-keymap ()
  "key bindings for java-add-on"
  ;;(define-key java-mode-map (kbd "RET") 'c-newline-and-perhaps-comment)
  ;;(define-key java-mode-map [(meta f7)]                   'narrow-to-my-firms-license)
  (define-key java-mode-map [(control c) (i)]                   'java-add-on-do-import)
  (define-key java-mode-map [(control c) (o)]                   'java-add-on-find-src-file)
  (define-key java-mode-map [(control c) (u)]                   'java-add-on-update-src-table)
  (define-key java-mode-map [(control c) (shift u)]             'java-add-on-update-src-table-i)
  (define-key java-mode-map [(control c) (meta u)]              'java-add-on-update-table)
  (define-key java-mode-map [(control c) (control r) (i)]       'java-add-on-alphabetize-imports)
  (define-key java-mode-map [(control c) (control r) (t)]       'java-add-on-alphabetize-throws)
  (define-key java-mode-map [(control c) (control r) (p)]       'java-add-on-astyle-buffer)
  (define-key java-mode-map [(control c) (r)]                   'java-add-on-normalize-buffer)
  (define-key java-mode-map [(control tab)] (make-hippie-expand-function
                                             '(java-add-on-hippie-expand-find-classname) t)))

(defun java-mode-common-setup ()
  ;(define-key java-mode-map (kbd "RET") 'c-newline-and-perhaps-comment)
  (setq comment-line-break-function 'c-newline-and-perhaps-comment)
) 
(autoload 'test-case-mode "test-case-mode" nil t)
(autoload 'enable-test-case-mode-if-test "test-case-mode")
(autoload 'test-case-find-all-tests "test-case-mode" nil t)
(autoload 'test-case-compilation-finish-run-all "test-case-mode")

(add-hook 'find-file-hook 'enable-test-case-mode-if-test)
(add-hook 'java-mode-hook 'java-mode-common-setup)
;; the c-newline-and-perhaps-comment is defined in stm-functions
(add-hook 'java-mode-hook 'java-mode-indent-annotations-setup)
;; add java-tags to emacs:
(add-hook 'java-mode-hook (lambda () (local-set-key (kbd "S-<tab>") 'java-complete)))

(add-hook 'java-mode-hook 'doxymacs-mode)

(add-hook 'java-mode-hook 'java-add-on-keymap)

;; add java-add-on keywords
(font-lock-add-keywords 'java-mode
                        java-add-on-highlight
                        "'")

;; ----------------------------------
;; wikimarkup




;; -------------------------------------------------
;; ReST 
;; -------------------------------------------------
(define-key rst-mode-map "\M-\r" 'rst-adjust-decoration)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variable settings

;; reduce number of standard keypresses for Steen
(fset 'yes-or-no-p 'y-or-n-p)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

; improving ido-mode
(setq ido-enable-flex-matching t)
(setq ido-create-new-buffer 'always)


;the color-theme my screen likes, is not a printer favorite.
(defun print-to-pdf ()
  (interactive)

  (setq ps-paper-type 'a4)
  (setq ps-font-size '(9 . 10.5))
  (setq ps-n-up-printing 1)
  (setq printer-name "pdf")
  (funcall stm-print-theme)

  (ps-print-buffer-with-faces)

;;;   (ps-spool-buffer-with-faces)
;;;   (switch-to-buffer "*PostScript*")
;;;   (write-file "/tmp/tmp.ps")
;;;   (kill-buffer "tmp.ps")
;;;   (setq cmd (concat "ps2pdf14 /tmp/tmp.ps ./" (buffer-name) ".pdf")) 
;;;   (shell-command cmd)
;;;   (shell-command "rm /tmp/tmp.ps")
;;;   (message (concat "Saved to: " (buffer-name) ".pdf"))
  (funcall stm-color-theme)
;  (highlight-current-line-set-bg-color shm-highlight)
  )

(defun print-to-minolta ()
  (interactive)

  (setq ps-paper-type 'a4)
  (setq ps-font-size '(9 . 10.5))
  (setq ps-n-up-printing 1)
  (setq printer-name "Minolta")
  (funcall stm-print-theme)

  (ps-print-buffer-with-faces)

;;;   (ps-spool-buffer-with-faces)
;;;   (switch-to-buffer "*PostScript*")
;;;   (write-file "/tmp/tmp.ps")
;;;   (kill-buffer "tmp.ps")
;;;   (setq cmd (concat "ps2pdf14 /tmp/tmp.ps ./" (buffer-name) ".pdf")) 
;;;   (shell-command cmd)
;;;   (shell-command "rm /tmp/tmp.ps")
;;;   (message (concat "Saved to: " (buffer-name) ".pdf"))
  (funcall stm-color-theme)
;  (highlight-current-line-set-bg-color shm-highlight)
  )

;make all emacs backupfiles go into ~/tmp/emacs
(setq backup-directory-alist
      '(("." . "~/tmp/emacs")))

;;always follow symlinks
(setq vc-follow-symlinks t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; orgmode variables

;;I use org-mode from the git repos. Currently installed is: do eval-last-sexp on next line
;; (org-version)

; I prefer return to activate a link
; Carsten tells us (http://article.gmane.org/gmane.emacs.orgmode/2088/match=return+follows+link),
; that we need to set the variable _before_ running org.el (or org-install)
; go figure...
(setq org-return-follows-link t)

;; org-mode customizations
(if (file-exists-p "~/.org/org.emacs")
    (load-file "~/.org/org.emacs"))
;; org-mode keybindings
(add-hook 'org-load-hook
          (lambda ()
            
            (define-key 'outline-mode-map "\C-cl" 'org-store-link)
            (define-key 'outline-mode-map "\C-ca" 'org-agenda)
            (define-key 'outline-mode-map "\C-cb" 'org-iswitchb)
            (define-key 'outline-mode-map "\C-cr" 'org-remember)
            ))
(setq org-CUA-compatible t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; programming language specifics

;;; python ;;;

(setq python-mode-hook
     '(lambda () (progn
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



; python default http://www.python.org/dev/peps/pep-0008/
;(setq-default tab-width 4) ; listed above

;; Highlight long lines on python mode in order to comply with pep 8
(font-lock-add-keywords
 'python-mode
 '(("^[^\n]\\{80\\}\\(.*\\)$"
    1 font-lock-warning-face prepend)))

(autoload 'python-mode "python-mode" "Python Mode." t)

(add-to-list 'interpreter-mode-alist '("ipython" . python-mode))

;; I really need to configure this...
(global-set-key [C-tab] 'hippie-expand)
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-dabbrev-visible
        try-expand-dabbrev-all-buffers
        try-expand-dabbrev-from-kill
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-all-abbrevs
        try-expand-list
        try-expand-line
))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; jeg foretrækker ansi-term som min shell og naturligvis zshell
(global-set-key [M-f2] '(lambda () (interactive) (ansi-term "/bin/zsh" "terminal")))

;;bookmarking
(global-set-key [f8] 'bm-toggle)
(global-set-key [S-f8] 'bm-next)
(global-set-key [S-C-f8] 'bm-previous)
(global-set-key [M-f8] 'bm-all) ;shows all bms in all buffers
; see variables for more info on the bookmarks

;; bury the buffer
(global-set-key [f9] 'bury-buffer)

;; kill the buffer
(global-set-key [C-f9] 'kill-buffer)


;; custom functions bound here, see under functions
(global-set-key [C-prior] 'shrink-window-1)
(global-set-key [C-next]  'grow-window-1)

(global-set-key [s-down] 'scroll-up-1)
(global-set-key [s-up] 'scroll-down-1)

(global-set-key [C-s-down] 'scroll-other-window-down-1)
(global-set-key [C-s-up] 'scroll-other-window-up-1)

;med logitech keyboard
(global-set-key [XF86AudioRaiseVolume] 'scroll-down-5)
(global-set-key [XF86AudioLowerVolume] 'scroll-up-5)

;hurtig switch mellem buffers i en frame
(global-set-key [s-left] 'previous-buffer)
(global-set-key [s-right] 'next-buffer)

(global-set-key "\M-o" 'other-window)

(global-set-key "\M-r" 'revert-buffer)

;; jump to line no.
(global-set-key "\M-g" 'goto-line)

;; mark-whole-buffer bruges tit ( brug i stedet C-x h)
;;(global-set-key "\M-a" 'mark-whole-buffer)

(global-set-key "\M-n" 'linum-mode)

(global-set-key "\M-v" 'vline-mode)

(global-set-key "\M-h" 'hl-line-mode)

(global-set-key [M-left] 'dedent-current-region)
(global-set-key [M-right] 'indent-current-region)

;; undo gør jeg mig meget i
(global-set-key [M-backspace] 'undo-only)

;; inserts predefined headers based on major mode
(global-set-key "\C-c\ h" 'insert-header)

;; see function defs
(global-set-key "\C-c\ t" 'insert-timestamp)

;; split window in four
(global-set-key "\C-x\ 4" 'split-window-in-four)

;kill-copy line
(global-set-key "\C-c\ l" 'copy-line)

;I really hate hitting shift-ctrl-meta-5 for this
(global-set-key "\C-c\ %" 'query-replace-regexp)

;reverse of C-k
(global-set-key "\C-l" 'backwards-kill-line) ; C-u in zsh

;; see printer variables for more info
(global-set-key "\C-cp" 'print-to-pdf)


;; does a search at point
(global-set-key "\C-c\ s" 'search-expr-at-point)

;; ibuffer er bare bedre
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; un-bindings:
;;;;;;;;;;;;;;;
;; ingen godnat til emacs
(when window-system
    (global-unset-key (kbd "C-z")))

;; jeg mailer andetsteds fra
(global-unset-key (kbd "C-x m"))

;; insert: nej, hellere yank
(global-unset-key [insert])
(global-set-key [insert] 'yank)

;; jeg rammer af en eller anden grund hele tiden denne tastkombo...
(global-unset-key (kbd "C-o"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; variables ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; make ediff not open separate frame
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;bookmarks only places mark at the left
(setq bm-highlight-style (quote bm-highlight-only-fringe))
;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)
 

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

;; Scroll step - how much the screen scrolls up and down.
(setq-default scroll-step 1)
(setq-default scroll-conservatively 1000)

;; enlarge bytes for undo's (from 20000)
(setq undo-strong-limit 150000)
(setq undo-limit 100000)

;; Increase the maximum size on buffers that should be fontified
(setq font-lock-maximum-size 1256000)

; no toolbar, no scrollbar, no menubar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
;(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; do various stuff based on the ip address we recieve
(let ((address (shell-command-to-string "ifconfig  | grep 'inet addr' | awk -F: '{print $2}' | awk '{print $1}' | grep -v '^127.'")))
  (cond ((string-match "^172\\." address)
         ;; at dbc:
         (setq my-org-file "dbc.org")
         (setq user-mail-address "stm@dbc.dk"))
        ((string-match "^192\\." address)
         ;; at home:
         (setq my-org-file "home.org"))
        (t
         ;; anywhere else
         (setq my-org-file "home.org"))))
