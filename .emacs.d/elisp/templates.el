;; -*- emacs-lisp -*- 
;; -*- coding: utf-8 -*-
;; tilføj til .emacs:
;; (require 'templates)
;; denne fil indlæser tempo for dig.
 
(require 'tempo)


(tempo-define-template "cs-function-header" 
  '("///<summary>"(p "summary: ") "</summary>\n"
    "///<remarks>"(p "remarks: ") "</remarks>\n"
    ))

(tempo-define-template "cs-main-clause"
  '("public static void Main( string[] args ){\n"
    "\n"
    "}\n"
    )
)

(tempo-define-template "svn-cs-header"
  '(
    "/** \\file\n"
    "* \\brief "(p "brief description: ")"\n"
    "*\n"
    "* $Date$\n"
    "* $Revision$\n"
    "* $Author$\n"
    "* $HeadURL$\n"
    "*/\n"
    ))

(tempo-define-template "svn-elisp-header"
  '(";; $Date$\n"
    ";; $Revision$\n"
    ";; $Author$\n"
    ";; $HeadURL$\n"
    ";;\n"
    ))

;; XML
(tempo-define-template "xml-like-header"
 '("<?xml version=\"1.0\"?>\n"
   "\n"
   "<!-- Author: " user-full-name " \"" user-mail-address "\" -->\n"
   "<!-- Date: " (format-time-string "%B %e, %Y" (current-time)) " -->\n"
   ))

(tempo-define-template "python-header"
  '("#!/usr/bin/env python\n" 
    "# -*- coding: utf-8 -*-\n"
    "# -*- mode: python -*-\n"
    ))

(tempo-define-template "python-main-clause"
  '("if __name__ == '__main__' :\n"
    "  "(p "expression: ") "\n"
    )
)

(tempo-define-template "sh-like-header"
  '("#!/bin/sh\n"
    "# -*- coding: utf-8 -*-\n"
    )
)

(defun insert-function-header ()
  (interactive)
  (cond 
   ((eq major-mode 'csharp-mode) (tempo-template-cs-function-header))
))

(defun insert-main ()
  (interactive)
  (cond
   ((eq major-mode 'python-mode) (tempo-template-python-main-clause))
   )
)

(defun insert-header ()
  (interactive)
  (goto-char (point-min))
  (cond 
;   ((eq major-mode 'csharp-mode) (tempo-template-c-like-header))
   ((eq major-mode 'xml-mode) (tempo-template-xml-like-header))
   ((eq major-mode 'python-mode) (tempo-template-python-header))
   ((eq major-mode 'emacs-lisp-mode) (tempo-template-svn-elisp-header))
   ((eq major-mode 'sh-mode) ( tempo-template-sh-like-header))
))

;; c# shortcuts

(tempo-define-template "cs-write"
  '( "Console.WriteLine( \"" (p "write: ") "\" );" n > 
     ))

;(define-key csharp-mode-map "\C-cw" 'tempo-template-cs-write)

(provide 'templates)
