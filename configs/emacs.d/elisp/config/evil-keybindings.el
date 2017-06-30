(evil-global-set-key 'normal (kbd "<left>") 'windmove-left )
(evil-global-set-key 'normal (kbd "<right>") 'windmove-right )
(evil-global-set-key 'normal (kbd "<up>") 'windmove-up )
(evil-global-set-key 'normal (kbd "<down>") 'windmove-down )

(define-key evil-normal-state-map (kbd "S-<return>" ) "O-<esc>" )
(define-key evil-normal-state-map (kbd "C-S-<return>" ) "o-<esc>" )

(provide 'evil-keybindings)
