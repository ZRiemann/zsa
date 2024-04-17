;; -*- mode: emacs-lisp; lexical-binding: t -*-
(setq gts-translate-list '(("en" "zh")))

(setq gts-default-translator
      (gts-translator
       ;; :picker (gts-prompt-picker)
       :engines (list (gts-bing-engine))
       ;; :render (gts-buffer-render)
       ;; :splitter (gts-paragraph-splitter)
       ))
