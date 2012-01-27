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
;(color-theme-initialize)

;; color-themes that are good for me:
;;(setq stm-color-theme 'color-theme-clarity)
;; (setq stm-color-theme 'color-theme-billw)
;; (setq stm-color-theme 'color-theme-emacs-nw)
;(color-theme-oswald)
;; (setq stm-color-theme 'color-theme-parus)
;; (setq stm-color-theme 'color-theme-pok-wob)
;; (setq stm-color-theme 'color-theme-taming-mr-arneson)
;; (setq stm-color-theme 'color-theme-charcoal-black)
;;(color-theme-calm-forest)

;; vertical and horisontal lines for easier navigation:
(require 'vline)
(require 'hl-line)
; ... and set colors:
(set-face-background 'hl-line "grey10")
(set-face-background 'vline "grey10")

(show-paren-mode t)
;;(require 'highlight-parentheses)
;;(highlight-parentheses-mode t)

;; line-numbering
(require 'linum)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

;; Uniquify buffer names, see http://www.ysbl.york.ac.uk/~emsley/software/stuff/uniquify.el
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

(defun toggle-minimal-mode (fs)
  (interactive "P")
  (defun fullscreen-margins nil
    (if (and (window-full-width-p) (not (minibufferp)))
	(set-window-margins nil (/ (- (frame-width) 120) 2) (/ (- (frame-width) 120) 2))
      (mapcar (lambda (window) (set-window-margins window nil nil)) (window-list))))

  (cond (menu-bar-mode
	  (menu-bar-mode -1) (tool-bar-mode -1) (scroll-bar-mode -1)
	   (set-frame-height nil (+ (frame-height) 4))
	    (if fs (progn (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
						       '(1 "_NET_WM_STATE_FULLSCREEN" 0))
			         (add-hook 'window-configuration-change-hook 'fullscreen-margins))))
	(t (menu-bar-mode 1) (tool-bar-mode 1) (scroll-bar-mode 1)
	      (when (frame-parameter nil 'fullscreen)
		     (remove-hook 'window-configuration-change-hook 'fullscreen-margins)
		          (x-send-client-message nil 0 nil "_NET_WM_STATE" 32
						     '(0 "_NET_WM_STATE_FULLSCREEN" 0))
			       (set-window-buffer (selected-window) (current-buffer)))
	         (set-frame-width nil (assoc-default 'width default-frame-alist)))))

(global-set-key [C-f11] 'toggle-minimal-mode)

;; makes the emacs frame title display the absolute path of the buffer-file-name
(setq frame-title-format "%f")

(provide 'ui)
