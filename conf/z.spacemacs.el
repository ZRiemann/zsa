(defun zriemann/pyim-config ()
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
	  )
	(defun zriemann/cnfonts-config ()
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
	  )
	(defun kinono/post-init-org ()
	  ;; 终端下 M-RET 是主模式 leader key，所以把 org-meta-return 绑到 M-RET M-RET 上
	  (spacemacs/set-leader-keys-for-major-mode 'org-mode
	    "M-RET" 'org-meta-return)
	  (spacemacs|use-package-add-hook org
	    :post-config
	    ;; 让中文也可以不加空格就使用行内格式
	    (setcar (nthcdr 0 org-emphasis-regexp-components) " \t('\"{[:nonascii:]")
	    (setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,:!?;'\")}\\[[:nonascii:]")
	    (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
	    (org-element-update-syntax)
	    ;; 规定上下标必须加 {}，否则中文使用下划线时它会以为是两个连着的下标
	    (setq org-use-sub-superscripts "{}")
	    ;; 放大预览倍数
	    (plist-put org-format-latex-options :scale 1.5)
	    (plist-put org-format-latex-options :html-scale 1.5)
	    (setq-default org-preview-latex-default-process 'dvisvgm)
	    )
	)
	(defun zriemann/general-config ()
	  (vertico-mode t)
	  (setq completion-styles '(orderless))
	  (marginalia-mode t)
	  (global-set-key (kbd "C-;") 'embark-act)
	  (setq prefix-help-command 'embak-prefix-help-command)
	  (setq make-backup-files nil)
	  (global-set-key (kbd "C-s") 'consult-line)

	  (global-company-mode 1)
	  (setq company-minimum-prefix-length 1)
	  (setq company-idle-delay 0)

	  ;; 显示行号
	  (global-linum-mode 1)
	  (icomplete-mode 1)
	  )

(defun zriemann/init()
  (setq configuration-layer-elpa-archives
		    '(("melpa-cn" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")
		      ("org-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/org/")
		      ("gnu-cn"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")))
  )
(defun zriemann/load()
  (require 'pyim)
	(require 'pyim-basedict)
	(require 'pyim-cregexp-utils)
	(require 'cnfonts)
  )
(defun zriemann/config()
  (zriemann/general-config)
	(zriemann/pyim-config)
	(zriemann/cnfonts-config)
	(kinono/post-init-org)
  )
