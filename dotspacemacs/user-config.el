;; -*- mode: emacs-lisp; lexical-binding: t -*-

;; M-x helper
(vertico-mode t)

;; orderless
(setq completion-styles '(orderless))

;; marginalia
(marginalia-mode t)

;; embark
(global-set-key (kbd "C-;") 'embark-act)
(setq prefix-help-command 'embak-prefix-help-command)
(setq make-backup-files nil)

;; consult-line
(global-set-key (kbd "C-s") 'consult-line)

;; company-mode
(global-company-mode 1)
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0)

;; 显示行号
;; (global-linum-mode 1)
(icomplete-mode 1)
