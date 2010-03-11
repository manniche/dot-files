;; no toolbar, no scrollbar, no menubar
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; stop cursor from blinking
(if (fboundp 'blink-cursor-mode) (blink-cursor-mode 0))

;; show time on status bar
(setq display-time-format "%R %d-%m-%y")
(display-time)

;; Turn on column numbering in status line
(column-number-mode t)

;; color themes
(require 'color-theme)
(color-theme-initialize)

;; color-themes that are good for me:
;;(setq stm-color-theme 'color-theme-clarity)
;; (setq stm-color-theme 'color-theme-billw)
;; (setq stm-color-theme 'color-theme-emacs-nw)
;; (setq stm-color-theme 'color-theme-oswald)
;; (setq stm-color-theme 'color-theme-parus)
;; (setq stm-color-theme 'color-theme-pok-wob)
;; (setq stm-color-theme 'color-theme-taming-mr-arneson)
 (setq stm-color-theme 'color-theme-charcoal-black)

;; vertical and horisontal lines for easier navigation:
(require 'vline)
(require 'hl-line)
; ... and set colors:
(set-face-background 'hl-line "grey10")
(set-face-background 'vline "grey10")

;(setq stm-print-theme 'color-theme-high-contrast)

(funcall stm-color-theme)

(show-paren-mode t)

;; line-numbering
(require 'linum)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

;; Uniquify buffer names, see http://www.ysbl.york.ac.uk/~emsley/software/stuff/uniquify.el
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(provide 'ui)