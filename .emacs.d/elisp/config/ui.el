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
;(color-theme-oswald)
;; (setq stm-color-theme 'color-theme-parus)
;; (setq stm-color-theme 'color-theme-pok-wob)
;; (setq stm-color-theme 'color-theme-taming-mr-arneson)
;; (setq stm-color-theme 'color-theme-charcoal-black)
(color-theme-calm-forest)

;; vertical and horisontal lines for easier navigation:
(require 'vline)
(require 'hl-line)
; ... and set colors:
(set-face-background 'hl-line "grey10")
(set-face-background 'vline "grey10")

;fonts, dunno how this will pan out
;(set-frame-font "Inconsolata-12")
;(set-face-font 'default " -*-bitstream vera sans mono-medium-r-*-*-*-120-*-*-*-*-iso10646-*")
;(set-face-font 'default "-outline-bitstream vera sans mono-normal-r-normal-normal-12-90-96-96-c-*-iso10646-1")

(show-paren-mode t)
(require 'highlight-parentheses)
(highlight-parentheses-mode t)

;; line-numbering
(require 'linum)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

;; Uniquify buffer names, see http://www.ysbl.york.ac.uk/~emsley/software/stuff/uniquify.el
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

;; showing file permission bits in the modeline (http://superuser.com/questions/547803/showing-file-permission-bits-in-the-modeline-of-emacs/549146)
;; New variable to contain buffer file permission format construct.
(defvar my-mode-line-buffer-permissions
  '(:eval (when (buffer-file-name) (format " %04o" (file-modes (buffer-file-name))))))
;; The variable must be marked as "risky" (see C-h v mode-line-format)
(put 'my-mode-line-buffer-permissions 'risky-local-variable t)
;; And finally add it right after the file name:
(setq-default
 mode-line-buffer-identification
 (append mode-line-buffer-identification (list 'my-mode-line-buffer-permissions)))

(provide 'ui)
