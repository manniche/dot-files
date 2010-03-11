;Time-stamp: <2010-03-09 10:05:28 stm>

;;---------------------------------------------------------
;;  Load Paths for general .el files for all configurations
;;---------------------------------------------------------

( add-to-list 'load-path "~/.emacs.d/elisp" )
( add-to-list 'load-path "~/.emacs.d/elisp/config" )
( add-to-list 'load-path "~/.emacs.d/elisp/color-theme" )

(defvar my-customize-file "~/.emacs.d/settings/custom.el")

(provide 'init)