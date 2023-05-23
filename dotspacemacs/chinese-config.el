;; -*- mode: emacs-lisp; lexical-binding: t -*-

;;================================================================================
;; cnfonts
;; 让 cnfonts 在 Emacs 启动时自动生效。
(cnfonts-mode 1)
;; 添加两个字号增大缩小的快捷键
;; (define-key cnfonts-mode-map (kbd "C--") #'cnfonts-decrease-fontsize)
;; (define-key cnfonts-mode-map (kbd "C-=") #'cnfonts-increase-fontsize)
(setq cnfonts-use-face-font-rescale t)
(defvar my-line-spacing-alist
	'((9 . 0.1) (10 . 0.9) (11.5 . 0.2)
	  (12.5 . 0.2) (14 . 0.2) (16 . 0.2)
	  (18 . 0.2) (20 . 1.0) (22 . 0.2)
	  (24 . 0.2) (26 . 0.2) (28 . 0.2)
	  (30 . 0.2) (32 . 0.2)))

(defun my-line-spacing-setup (fontsizes-list)
	(let ((fontsize (car fontsizes-list))
		    (line-spacing-alist (copy-list my-line-spacing-alist)))
	  (dolist (list line-spacing-alist)
		  (when (= fontsize (car list))
		    (setq line-spacing-alist nil)
		    (setq-default line-spacing (cdr list))))))

(add-hook 'cnfonts-set-font-finish-hook #'my-line-spacing-setup)
;; (cl-prettyprint (font-family-list))

;;================================================================================
;; pyim
(pyim-basedict-enable)   ; 拼音词库，五笔用户 *不需要* 此行设置
(setq default-input-method "pyim")
;;(global-set-key (kbd "C-\\") 'toggle-input-method)
;; 显示 10 个候选词。
(setq pyim-page-length 10)
;; 金手指设置，可以将光标处的编码（比如：拼音字符串）转换为中文。
;;(global-set-key (kbd "M-j") 'pyim-convert-string-at-point)
;; 按 "C-<return>" 将光标前的 regexp 转换为可以搜索中文的 regexp.
;;(define-key minibuffer-local-map (kbd "C-<return>") 'pyim-cregexp-convert-at-point)
;; 设置 pyim 默认使用的输入法策略，我使用全拼。
(pyim-default-scheme 'quanpin)
;; (pyim-default-scheme 'wubi)
;; (pyim-default-scheme 'cangjie)
;; 设置 pyim 是否使用云拼音
(setq pyim-cloudim 'baidu)
(pyim-isearch-mode 1)
