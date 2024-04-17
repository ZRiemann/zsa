;; -*- mode: emacs-lisp; lexical-binding: t -*-

;; M-x helper
(vertico-mode t)

;; orderless
;; 模糊匹配
;; (setq completion-styles '(orderless))

;; marginalia
;; 注释直接显示在minibuffer,(未生效)
(marginalia-mode t)

;; embark
(global-set-key (kbd "C-;") 'embark-act)
(setq prefix-help-command 'embak-prefix-help-command)
(setq make-backup-files nil)

;; consult-line
;; 增强搜索字符串
(global-set-key (kbd "C-s") 'consult-line)
;;(global-set-key (kbd "C-s") 'consult-buffer)

;; company-mode
(global-company-mode 1)
(setq company-minimum-prefix-length 1)
(setq company-idle-delay 0)


;;(setq wgrep-auto-save-buffer t)

;;(eval-after-load 'consult
;;  '(eval-after-load 'embark
;;     '(progn
;;	      (require 'embark-consult)
;;	      (add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode))))


;; grep < ack < ag < ripgrep (rg)
;; M-x consult-ripgrep xxx
;; 显示行号
;; (global-linum-mode 1)
;; (show-parent-mode t)

;; 补全命令 use vertico-mode
;;(setq tab-always-indent 'complete)
;;(icomplete-mode 1)

;; 自动换行 1 on, 0 off
(global-visual-line-mode 1)
;; 禁止鼠标滚轮（有滚轮导致spacemacs卡死现象）
(mouse-wheel-mode -1)
(xterm-mouse-mode 1)
;; 自动保存
(auto-save-mode t)
(setq auto-save-interval 20)
(auto-save-visited-mode 1)
(setq auto-save-visited-interval 2)

;; socks5 proxy
;;(setq socks-override-functions 1)
;;(setq socks-noproxy '("localhost"))
;;(require 'socks)
;;(setq socks-server '("Socks5 Proxy" "localhost" 9090 5))

;; http proxy
;;(setq url-proxy-services
;;      '(("http"     . "127.0.0.1:9090")
;;        ("https"    . "127.0.0.1:9090")
;;        ("no_proxy" . "^\\(localhost\\|10\\..*\\|192\\.168\\..*\\")")))
