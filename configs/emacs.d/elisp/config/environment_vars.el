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
(setq user-mail-address "steen@manniche.net")
(setq user-full-name "Steen Manniche")

;; have google chrome open links by default
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "firefox")


(setq rst-level-face-base-color "nil")

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


;; make del and insertions overwrite a selected region
(require 'delsel)
(delete-selection-mode t)

;; Moves mouse pointer to upper right corner, if the cursor is in the vicinity
(mouse-avoidance-mode (quote exile))

;; Scroll step - how much the screen scrolls up and down.
(setq-default scroll-step 1)
(setq-default scroll-conservatively 1000)

;;play nice with the other kids: respect the x-clipboard
(setq x-select-enable-clipboard t)

;;indicate empty lines
(setq indicate-empty-lines t)
;; displays contents of the kill-ring in a separate buffer
;; (require 'browse-kill-ring)
;; (browse-kill-ring-default-keybindings)

;; instead of auto-reverting - which works somewhat against
;; expectations (which in this case would be my expectations of using
;; a very shiny little silver spoon as sledge-hammer) - emacs comes
;; with userlock, which does exactly what I want (making big holes in
;; stuff)
(load "userlock")

;;;;;;;;;;;;;;;;
;;; LaTeX stuff
;; Math mode 
(add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)


;; org-mode
;(require 'org-latex)

;; Beamer with org-mode
;; allow for export=>beamer by placing

;; #+LaTeX_CLASS: beamer in org files
(unless (boundp 'org-export-latex-classes)
  (setq org-export-latex-classes nil))
(add-to-list 'org-export-latex-classes
  ;; beamer class, for presentations
  '("beamer"
     "\\documentclass[11pt]{beamer}\n
      \\mode<{{{beamermode}}}>\n
      \\usetheme{{{{beamertheme}}}}\n
      \\usecolortheme{{{{beamercolortheme}}}}\n
      \\beamertemplateballitem\n
      \\setbeameroption{show notes}
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{hyperref}\n
      \\usepackage{color}
      \\usepackage{listings}
      \\lstset{numbers=none,language=[ISO]C++,tabsize=4,
  frame=single,
  basicstyle=\\small,
  showspaces=false,showstringspaces=false,
  showtabs=false,
  keywordstyle=\\color{blue}\\bfseries,
  commentstyle=\\color{red},
  }\n
      \\usepackage{verbatim}\n
      \\institute{{{{beamerinstitute}}}}\n          
       \\subject{{{{beamersubject}}}}\n"

     ("\\section{%s}" . "\\section*{%s}")
     
     ("\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}"
       "\\begin{frame}[fragile]\\frametitle{%s}"
       "\\end{frame}")))

  ;; letter class, for formal letters

  (add-to-list 'org-export-latex-classes

  '("letter"
     "\\documentclass[11pt]{letter}\n
      \\usepackage[utf8]{inputenc}\n
      \\usepackage[T1]{fontenc}\n
      \\usepackage{color}"
     
     ("\\section{%s}" . "\\section*{%s}")
     ("\\subsection{%s}" . "\\subsection*{%s}")
     ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
     ("\\paragraph{%s}" . "\\paragraph*{%s}")
     ("\\subparagraph{%s}" . "\\subparagraph*{%s}")))

;; beamer end


(provide 'environment_vars)
