;; -*- mode: emacs-lisp; lexical-binding: t -*-
;; ---------------------------------------
;; Org-mode configuration
;; ---------------------------------------

;; ---------------------------------------
;; Notes and Tasks

(with-eval-after-load 'org
  (setq
   ;; Define the location of the file to hold tasks
   org-default-notes-file "~/projects/todo-list.org"

   ;; Define a kanban style set of stages for todo tasks
   org-todo-keywords '((sequence "TODO" "DOING" "BLOCKED" "REVIEW" "|" "DONE" "ARCHIVED"))

   ;; Progress Log - add CLOSED: property & current date-time when TODO item enters DONE
   org-log-done 'time

   ;; Setting colours (faces) of task states
   ;; https://github.com/tkf/org-mode/blob/master/lisp/org-faces.el#L376
   ;; Using X11 colour names from: https://en.wikipedia.org/wiki/Web_colors
   ;; Using `with-eval-after-load' as a hook to call this setting when org-mode is run
   org-todo-keyword-faces
   '(("TODO" . "SlateGray")
     ("DOING" . "DarkOrchid")
     ("BLOCKED" . "Firebrick")
     ("REVIEW" . "Teal")
     ("DONE" . "ForestGreen")
     ("ARCHIVED" .  "SlateBlue"))))

;; Set TODO keyword faces if over-ridden by theme.
(defun practicalli/set-todo-keyword-faces ()
  (interactive)
  (setq hl-todo-keyword-faces
        '(("TODO" . "SlateGray")
          ("DOING" . "DarkOrchid")
          ("BLOCKED" . "Firebrick")
          ("REVIEW" . "Teal")
          ("DONE" . "ForestGreen")
          ("ARCHIVED" .  "SlateBlue"))))
;; ---------------------------------------


;; ---------------------------------------
;; customize org-mode's checkboxes with unicode symbols
(add-hook
 'org-mode-hook
 (lambda ()
   "Beautify Org Checkbox Symbol"
   (push '("[ ]" . "☐") prettify-symbols-alist)
   (push '("[X]" . "☑" ) prettify-symbols-alist)
   (push '("[-]" . "❍" ) prettify-symbols-alist)
   (prettify-symbols-mode)))
;; ---------------------------------------

;; ----------------------------------------
;; active Babel languages
;;
(org-babel-do-load-languages
 'org-babel-load-languages
 '((C . t)
   (js . t)
   (python . t)
   (emacs-lisp . nil)
   (scheme . nil)
   (ditaa . nil)
   (lisp . nil)
   (matlab . nil)
   (octave . nil)
   (java . nil)
   (R . nil)
   ;;   (emacs-lisp . nil)
   ))

;; ----------------------------------------
;; org-latex config
;; 终端下 M-RET 是主模式 leader key，所以把 org-meta-return 绑到 M-RET M-RET 上
(spacemacs/set-leader-keys-for-major-mode 'org-mode
  "M-RET" 'org-meta-return)
;; 放大预览倍数
(plist-put org-format-latex-options :scale 1.5)
(plist-put org-format-latex-options :html-scale 1.5)
(setq-default org-preview-latex-default-process 'dvisvgm) ;;'dvipng, 'convert, 'dvisvgm
;; CDLaTeX
;; (add-hook 'org-mode-hook #'turn-on-org-cdlatex)
;;(add-hook 'latex-mode-hook 'turn-on-org-cdlatex) ; with Emacs latex mode
;;(add-hook 'LaTex-mode-hook 'turn-on-org-cdlatex) ; with AUCTeX, LaTeX mode

(spacemacs|use-package-add-hook org
  :post-config
  ;; 让中文也可以不加空格就使用行内格式
  (setcar (nthcdr 0 org-emphasis-regexp-components) " \t('\"{[:nonascii:]")
  (setcar (nthcdr 1 org-emphasis-regexp-components) "- \t.,:!?;'\")}\\[[:nonascii:]")
  (org-set-emph-re 'org-emphasis-regexp-components org-emphasis-regexp-components)
  (org-element-update-syntax)
  ;; 规定上下标必须加 {}，否则中文使用下划线时它会以为是两个连着的下标
  (setq org-use-sub-superscripts "{}")
  )

