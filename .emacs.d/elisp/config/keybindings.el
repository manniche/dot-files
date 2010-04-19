;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key bindings ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


(defun my-keybindings ()

;(define-key rst-mode-map "\M-\r" 'rst-adjust-decoration)

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

(global-set-key [C-s-down] 'scroll-other-window-up-1)
(global-set-key [C-s-up] 'scroll-other-window-down-1)

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

;; I compile a lot
(global-set-key "\C-x\ \C-k" 'compile)

;; inserts predefined headers based on major mode
(global-set-key "\C-x\ h" 'insert-header)

;; see function defs
(global-set-key "\C-x\ t" 'insert-timestamp)

;; mark-whole-buffer bruges tit ( brug i stedet C-x h)
;;(global-set-key "\M-a" 'mark-whole-buffer)

(global-set-key "\M-n" 'linum-mode)

(global-set-key "\M-v" 'vline-mode)

(global-set-key "\M-h" 'hl-line-mode)

(global-set-key [M-left] 'dedent-current-region)
(global-set-key [M-right] 'indent-current-region)

;; undo gør jeg mig meget i
(global-set-key [M-backspace] 'undo-only)

;; split window in four
(global-set-key "\C-x\ 4" 'split-window-in-four)

;kill-copy line
(global-set-key "\C-l" 'copy-line)

;I really hate hitting shift-ctrl-meta-5 for this
(global-set-key "\C-c\ %" 'query-replace-regexp)

;reverse of C-k
(global-set-key "\C-u" 'backward-kill-line) ; C-u in zsh

;; see printer variables for more info
(global-set-key "\C-cp" 'print-to-pdf)
;(global-set-key "\C-cp" 'print-to-minolta)


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

  )

(provide 'keybindings)
