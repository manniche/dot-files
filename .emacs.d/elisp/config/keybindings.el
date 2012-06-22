;;bookmarking
(global-set-key (kbd "<f8>" ) 'bm-toggle)
(global-set-key (kbd "<f7>" ) 'bm-next)
(global-set-key (kbd "S-<f7>" ) 'bm-previous)
(global-set-key (kbd "S-<f8>" ) 'bm-all) ;shows all bms in all buffers
; see environments_vars.el for more info on the bookmarks

;hurtig switch mellem buffers i en frame
(global-set-key (kbd "M-<up>" ) 'previous-buffer)
(global-set-key (kbd "M-<down>" ) 'next-buffer)
; og alternativer
(global-set-key (kbd "C-<f9>") 'previous-buffer)
(global-set-key (kbd "C-<f10>") 'next-buffer)

;; see my-functions for definitions of these
(global-set-key (kbd "s-<up>" ) 'scroll-down-1)
(global-set-key (kbd "s-<down>" ) 'scroll-up-1)

(global-set-key (kbd "M-S-<up>" ) 'move-line-up)
(global-set-key (kbd "M-S-<down>" ) 'move-line-down)

(global-set-key (kbd "M-s-<up>" ) 'grow-window-1)
(global-set-key (kbd "M-s-<down>" ) 'shrink-window-1)

(global-set-key (kbd "M-r") 'revert-buffer)

(global-set-key (kbd "M-n") 'linum-mode)

(global-set-key (kbd "M-v") 'vline-mode)

(global-set-key (kbd "M-h") 'hl-line-mode)

(global-set-key (kbd "M-l") 'goto-line)

(global-set-key (kbd "<f9> c") 'calendar)

;; undo gør jeg mig meget i
(global-set-key (kbd "M-<backspace>") 'undo-only)

;; split window in four
(global-set-key (kbd "C-x 4") 'split-window-in-four)

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

;; org mode keys
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "<f9> n") 'org-narrow-to-subtree)
(global-set-key (kbd "<f9> o") 'bh/make-org-scratch)
(global-set-key (kbd "<f9> v") 'visible-mode)
(global-set-key (kbd "<f9> SPC") 'bh/clock-in-last-task)
(global-set-key (kbd "M-<f9>") 'org-toggle-inline-images)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "C-c r") 'org-capture)
(global-set-key (kbd "<f11>") 'org-capture)


;; Change the q key in the agenda so instead of killing the agenda
;; buffer it merely buries it to the end of the buffer list. This
;; allows me to pull it back up quickly with the q speed key or f9 f9
;; and regenerate the results with g.
(add-hook 'org-agenda-mode-hook
          (lambda ()
            (define-key org-agenda-mode-map "q" 'bury-buffer))
          'append)


(provide 'keybindings)

