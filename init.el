;;; init.el --- The Emacs init file. -*- lexical-binding: t; -*-

;; source: https://github.com/zarkone/literally.el/blob/master/README.org
(let ((gc-cons-threshold most-positive-fixnum))
  ;; Set repositories
  (require 'package)
  (setq-default
   custom-file "~/.emacs.d/.custom-vars" ;; set custom file but never load it; config custom with use-package instead
   load-prefer-newer t
   package-enable-at-startup nil)

  (load custom-file)

  (setq
   package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "http://melpa.org/packages/")))

  (package-initialize)

  ;; Bootstrap 'use-package'
  (unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
  (eval-when-compile
  (require 'use-package))

  (require 'use-package-ensure)
  (setq use-package-always-ensure t
        use-package-always-defer t
        use-package-expand-minimally t)

  ;; Use latest Org
  (setq org-directory "~/zettel")
  (use-package org
    :mode (("\\.org$" . org-mode))
    :custom
    (org-startup-truncated nil)
    (org-startup-with-inline-images t)
    (org-return-follows-link  t)
    (org-todo-keywords '((sequence "TODO" "IN-PROGRESS" "WAIT" "|" "DONE" "CANCELLED")))
    (org-todo-keyword-faces
     '(("TODO" . org-warning)
       ("HOLD" . (:foreground "purple" :weight bold))
       ("CANCELLED" . (:foreground "pink"))))
    (setqorg-capture-templates
     '(("s" "scan" entry (file+olp+datetree "~/org/ztl/radio/scan-log.org")
        "* %U | freq: %^{FREQ} | %^{suggestions| } \n %?"
        :empty-lines 0
        :tree-type week
        )))
    (org-agenda-files (list org-directory))
    (org-src-fontify-natively t)
    (org-fontify-whole-heading-line t)
    (org-src-preserve-indentation t)
    (org-completion-use-ido t)
    ;; Turn off the confirmation for code eval when using org-babel
    (org-confirm-babel-evaluate nil)
    ;; Configure export using a css style sheet
    (org-html-htmlize-output-type 'css)
    ;; (setq org-html-head exordium-org-export-css-stylesheet)
    (org-support-shift-select t)
    (org-babel-python-command "ipython3 --simple-prompt")
    ;; (setq org-babel-sh-command "./sh_stderr.sh")
    :bind
      ("C-c l" . 'org-store-link)
      ("C-c a" . 'org-agenda)
      ("C-c c" . 'org-capture)
      ("C-c v" . 'org-capture-goto-last-stored))

  ;; Tangle configuration
  (org-babel-load-file (expand-file-name "config.org" user-emacs-directory))
  (garbage-collect))
(put 'dired-find-alternate-file 'disabled nil)
