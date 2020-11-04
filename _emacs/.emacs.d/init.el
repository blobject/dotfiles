(package-initialize)
;(require 'flycheck)
(require 'dot-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; linum

(defvar my/linum-format "%1d")

(defun my/linum-get-format ()
  "Add a space after linum"
  (let* ((w (length (number-to-string (count-lines (point-min) (point-max)))))
         (fmt (concat "%" (number-to-string w) "d ")))
    (setq my/linum-format fmt)))

(defun my/linum (line)
  "Propertize custom linum format."
  (propertize (format my/linum-format line) 'face 'linum))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; mode-line

(defvar my/buffer-status
  (quote
    (:eval (if (buffer-modified-p) "x" (if buffer-read-only "r" " ")))))

(defun my/mode-line-fill (face reserve)
  "Return empty space using face, leaving reserve space on the right."
  (unless reserve (setq reserve 20))
  (propertize " " 'display
              `((space :align-to (- (+ right right-fringe right-margin)
                                    ,reserve)))))

(defvar my/mode-line
  (list my/buffer-status
        " %b %l:%c"
        (setcdr (assq 'vc-mode mode-line-format)
                '((:eval (replace-regexp-in-string "^ Git[-:]" " " vc-mode))))
        " %m"
        ;(\` (flycheck-mode flycheck-mode-line))
        ;(\` (vc-mode vc-mode))
        ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-x customize

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist '((".*" . "~/bak/emacs/")))
 '(blink-cursor-mode nil)
 '(browse-url-browser-function 'browse-url-generic)
 '(browse-url-generic-program "firefox")
 '(c-basic-offset 2)
 '(c-default-style
   '((c-mode . "bsd")
     (c++-mode . "bsd")
     (java-mode . "java")
     (awk-mode . "awk")
     (other . "gnu")))
 '(column-number-mode t)
 '(compilation-message-face 'default)
 '(create-lockfiles nil)
 '(css-indent-offset 2)
 '(custom-enabled-themes '(cemant))
 '(custom-safe-themes
   '("2881d10dfeb0c0b8ae374d0fd40a7fce940807c9ae8114394ef181729a04410b" default))
 '(default-tab-width 2 t)
 '(electric-indent-inhibit t t)
 '(electric-pair-mode t)
 '(fringe-mode 0 nil (fringe))
 '(global-dot-mode t)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(indicate-empty-lines nil)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(initial-scratch-message "")
 '(isearch-lazy-highlight nil)
 '(js-indent-level 2)
 '(linum-format 'my/linum)
 '(menu-bar-mode nil)
 '(mode-line-format my/mode-line)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount '(1 ((shift) . 5) ((control) . 10)))
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("melpa" . "https://melpa.org/packages/")))
 '(package-selected-packages
   '(csharp-mode elixir-mode haskell-mode markdown-mode rust-mode dot-mode expand-region iy-go-to-char multiple-cursors paredit rainbow-delimiters web-mode hlinum))
 '(python-indent 2)
 '(read-quoted-char-radix 16)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(sml/col-number-format "%1c")
 '(sml/line-number-format "%1l")
 '(tab-stop-list (number-sequence 2 100 2))
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style 'post-forward nil (uniquify))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))
 '(face-font-family-alternatives '(("custom" "Roboto Mono" "NanumGothicCoding" "Source Han Sans" "FreeMono")))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "monospace" :height 85 :weight bold))))
 '(fixed-pitch-serif ((t (:family "FreeMono" :weight bold))))
 '(org-agenda-structure ((t (:inverse-video nil :underline nil :slant normal :weight bold :height 1.0))))
 '(org-document-title ((t (:weight bold :height 1.0))))
 '(org-level-1 ((t (:inherit nil :foreground "#36383f" :height 1.0))))
 '(org-level-2 ((t (:inherit nil :foreground "#3c56aa" :height 1.0))))
 '(org-level-3 ((t (:inherit nil :foreground "#237e6f" :height 1.0))))
 '(org-level-4 ((t (:inherit nil :foreground "#4b7d08" :height 1.0))))
 '(org-level-5 ((t (:inherit nil :foreground "#866c12" :height 0.9))))
 '(org-level-6 ((t (:inherit nil :foreground "#af913a" :height 0.9))))
 '(org-level-7 ((t (:inherit nil :foreground "#91328c" :height 0.9))))
 '(org-level-8 ((t (:inherit nil :foreground "#575a61" :height 0.9))))
 '(sml/line-number ((t (:weight bold))))
 '(sml/minor-modes ((t (:inherit sml/global :height 0.9))))
 '(sml/modes ((t (:inherit sml/global :weight bold :height 0.9))))
 '(web-mode-doctype-face ((t nil))))
 ;'(trailing-whitespace ((t (:background "#073642"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hooks

(add-hook 'find-file-hooks 'dot-mode-on)
;(add-hook 'after-init-hook 'global-company-mode)
;(add-hook 'after-init-hook 'global-flycheck-mode)
(add-hook 'after-init-hook 'hlinum-activate)
(add-hook 'org-mode-hook (lambda () (visual-line-mode) (org-indent-mode)))
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
;(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'geiser-mode-hook 'enable-paredit-mode)
(add-hook 'linum-before-numbering-hook 'my/linum-get-format)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
;(add-hook 'rust-mode-hook #'racer-mode)
;(add-hook 'racer-mode-hook #'company-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'web-mode-hook (lambda ()
  (if (equal web-mode-content-type "javascript")
    (web-mode-set-content-type "jsx"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto modes

;(add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode))
;(add-to-list 'auto-mode-alist '("^/var/log/" . syslog-mode))
;(add-to-list 'auto-mode-alist '("\\.log$" . syslog-mode))
(add-to-list 'auto-mode-alist '("\\..?css$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
;(flycheck-add-mode 'javascript-eslint 'web-mode)

(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; key bindings

(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 1)))
;(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-,") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-;") 'my/select-current-line)
;(global-set-key (kbd "C-:") 'avy-goto-char-timer)
(global-set-key (kbd "C-'") 'iy-go-up-to-char)
(global-set-key (kbd "C-\"") 'iy-go-to-char-backward)
(global-set-key (kbd "C-a") 'my/back-to-indentation-or-beginning)
(global-set-key (kbd "C-o") 'my/open-next-line)
(global-set-key (kbd "M-o") 'my/open-previous-line)
(global-set-key (kbd "<C-return>") 'er/expand-region)
(global-set-key (kbd "C-x /") 'my/toggle-selective-display)
(global-set-key (kbd "C-x 2") 'my/vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'my/hsplit-last-buffer)
;(global-set-key (kbd "C-x g") 'magit-status)
;(global-set-key (kbd "C-x y") 'browse-kill-ring)
(global-unset-key (kbd "C-x ]"))
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "M-C-\\"))
(global-unset-key (kbd "<C-down-mouse-1>"))
(global-unset-key (kbd "<C-down-mouse-2>"))
(global-unset-key (kbd "<C-down-mouse-3>"))
(global-unset-key (kbd "<S-down-mouse-1>"))
(global-unset-key (kbd "<S-down-mouse-2>"))
(global-unset-key (kbd "<S-down-mouse-3>"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; interactivity

(defun my/back-to-indentation-or-beginning ()
  "Do what I mean when I go back to beginning."
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
    (beginning-of-line)))

(defun my/vsplit-last-buffer (prefix)
  "Split window vertically and display last buffer."
  (interactive "p")
  (split-window-vertically)
  (other-window 1 nil)
  (if (= prefix 1) (switch-to-next-buffer)))

(defun my/hsplit-last-buffer (prefix)
  "Split window horizontally and display last buffer."
  (interactive "p")
  (split-window-horizontally)
  (other-window 1 nil)
  (if (= prefix 1) (switch-to-next-buffer)))

(defun my/select-current-line ()
  "Select current line."
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))

(defun my/open-next-line (arg)
  "Open new line after current line."
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (indent-according-to-mode))

(defun my/open-previous-line (arg)
  "Open new line before current line."
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (indent-according-to-mode))

(defun my/toggle-selective-display (column)
  "Fold code block."
  (interactive "p")
  (set-selective-display
    (if selective-display nil (or column 1))))

