(package-initialize)
(require 'flycheck)
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

(let ((c-w "#bbbbc3")
      (c-l "#95959d")
      (c-r "#a92636")
      (c-y "#8b6b02")
      (c-m "#9a1e98"))

  (defface my/l-face
    `((t (:background ,c-l :foreground ,c-w)))
    "mode-line custom light grey"
    :group 'faces)

  (defface my/r-face
    `((t (:background ,c-r :foreground ,c-w)))
    "mode-line custom red"
    :group 'faces)

  (defface my/y-face
    `((t (:background ,c-y :foreground ,c-w)))
    "mode-line custom yellow"
    :group 'faces))

(defvar my/buffer-status
  (quote
    (:eval (if (buffer-modified-p)
             (if buffer-read-only
               (propertize "+" (quote face) (quote my/y-face))
               (propertize "+" (quote face) (quote my/r-face)))
             (propertize (if buffer-read-only "^" "-")
                         (quote face) (quote my/l-face))))))

(defun my/mode-line-fill (face reserve)
  "Return empty space using face, leaving reserve space on the right."
  (unless reserve (setq reserve 20))
  (propertize " " 'display
              `((space :align-to (- (+ right right-fringe right-margin)
                                    ,reserve)))))

(defvar my/mode-line
  (list mode-line-front-space
        "%b "
        my/buffer-status
        " %m"
        (\` (vc-mode vc-mode))
        (\` (flycheck-mode flycheck-mode-line))
        (my/mode-line-fill (quote mode-line-inactive) 15)
        mode-line-mule-info
        "%c:%l "
        mode-line-percent-position
        mode-line-end-spaces))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; M-x customize

(custom-set-variables
 '(backup-directory-alist (quote ((".*" . "~/bak/emacs/"))))
 '(blink-cursor-mode nil)
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-program "icecat")
 '(c-basic-offset 2)
 '(c-default-style (quote ((c-mode . "bsd") (c++-mode . "bsd") (java-mode . "java") (awk-mode . "awk") (other . "gnu"))))
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(company-idle-delay 0)
 '(compilation-message-face (quote default))
 '(counsel-find-file-ignore-regexp nil)
 '(counsel-mode t)
 '(create-lockfiles nil)
 '(css-indent-offset 2)
 '(custom-enabled-themes (quote (cemant)))
 '(custom-safe-themes (quote ("5053246e1a33c5337fee519167a80fea394aac892ed422a5a1bdd63fae31b950" default)))
 '(default-tab-width 2 t)
 '(electric-indent-inhibit t t)
 '(electric-pair-mode t)
 '(fringe-mode 0 nil (fringe))
 '(global-dot-mode t)
 '(global-hl-line-mode t)
 '(global-linum-mode t)
 '(gnus-directory "/data/mail/gnus/news/")
 '(indent-tabs-mode nil)
 '(indicate-empty-lines nil)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(initial-scratch-message "")
 '(isearch-lazy-highlight nil)
 '(ivy-mode 1)
 '(js-indent-level 2)
 '(linum-format (quote my/linum))
 '(magit-diff-use-overlays nil)
 '(menu-bar-mode nil)
 '(message-directory "/data/mail/gnus/mail/")
 '(mode-line-format my/mode-line)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 5) ((control) . 10))))
 '(nnfolder-directory "/data/mail/gnus/mail/archive")
 '(package-archives (quote (("gnu" . "https://elpa.gnu.org/packages/") ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages (quote (boon csharp-mode cider clojure-mode company-auctex company-ghc company-go company-lua company-racer company-shell company-web counsel dot-mode flycheck flycheck-clojure flycheck-ghcmod flycheck-golangci-lint flycheck-rust flycheck-tcl geiser go-mode guix haskell-mode hlinum iy-go-to-char lua-mode magit markdown-mode multiple-cursors racer rainbow-delimiters rust-mode slime smart-mode-line smart-mode-line-powerline-theme web-mode auctex avy company ivy)))
 '(read-quoted-char-radix 16)
 '(scroll-bar-mode nil)
 '(send-mail-function (quote mailclient-send-it))
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(sml/col-number-format "%1c")
 '(sml/line-number-format "%1l")
 '(tab-stop-list (number-sequence 2 100 2))
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))
 ;'(face-font-family-alternatives '(("custom" "Source Code Pro" "NanumGothicCoding" "Source Han Sans" "FreeMono")))
 ;'(racer-cmd "~/.cargo/bin/racer")
 ;'(racer-rust-src-path "/usr/local/src/rust/src")

(custom-set-faces
 '(default ((t (:weight semi-bold :height 105 :family "Source Code Pro"))))
 '(fixed-pitch-serif ((t (:weight semi-bold :family "FreeMono"))))
 '(linum ((t (:height 100))))
 '(linum-highlight-face ((t (:height 100))))
 '(org-agenda-structure ((t (:inverse-video nil :underline nil :slant normal :weight bold :height 1.0))))
 '(org-document-title ((t (:weight bold :height 1.0))))
 '(org-level-1 ((t (:inherit nil :foreground "#3a393f" :height 1.0))))
 '(org-level-2 ((t (:inherit nil :foreground "#4051b0" :height 1.0))))
 '(org-level-3 ((t (:inherit nil :foreground "#007f68" :height 1.0))))
 '(org-level-4 ((t (:inherit nil :foreground "#437e00" :height 1.0))))
 '(org-level-5 ((t (:inherit nil :foreground "#8b6b02" :height 0.9))))
 '(org-level-6 ((t (:inherit nil :foreground "#a92636" :height 0.9))))
 '(org-level-7 ((t (:inherit nil :foreground "#9a1e98" :height 0.9))))
 '(org-level-8 ((t (:inherit nil :foreground "#5a595f" :height 0.9))))
 '(sml/line-number ((t (:weight bold))))
 '(sml/minor-modes ((t (:inherit sml/global :height 0.9))))
 '(sml/modes ((t (:inherit sml/global :weight bold :height 0.9)))))
 ;'(trailing-whitespace ((t (:background "#073642"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hooks

(add-hook 'find-file-hooks 'dot-mode-on)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'global-flycheck-mode)
(add-hook 'after-init-hook 'hlinum-activate)
;(add-hook 'after-init-hook 'sml/setup)
(add-hook 'org-mode-hook (lambda () (visual-line-mode) (org-indent-mode)))
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)
;(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;(add-hook 'geiser-mode-hook 'enable-paredit-mode)
(add-hook 'linum-before-numbering-hook 'my/linum-get-format)
;(add-hook 'lisp-mode-hook 'enable-paredit-mode)
;(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'company-mode)
;(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'web-mode-hook (lambda ()
  (if (equal web-mode-content-type "javascript")
    (web-mode-set-content-type "jsx"))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; auto modes

(add-to-list 'auto-mode-alist '("\\.pl$" . prolog-mode))
(add-to-list 'auto-mode-alist '("^/var/log/" . syslog-mode))
(add-to-list 'auto-mode-alist '("\\.log$" . syslog-mode))
(add-to-list 'auto-mode-alist '("\\..?css$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(flycheck-add-mode 'javascript-eslint 'web-mode)

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
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-,") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-;") 'my/select-current-line)
(global-set-key (kbd "C-:") 'avy-goto-char-timer)
(global-set-key (kbd "C-'") 'iy-go-up-to-char)
(global-set-key (kbd "C-\"") 'iy-go-to-char-backward)
(global-set-key (kbd "C-a") 'my/back-to-indentation-or-beginning)
(global-set-key (kbd "C-o") 'my/open-next-line)
(global-set-key (kbd "M-o") 'my/open-previous-line)
(global-set-key (kbd "<C-return>") 'er/expand-region)
(global-set-key (kbd "C-x /") 'my/toggle-selective-display)
(global-set-key (kbd "C-x 2") 'my/vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'my/hsplit-last-buffer)
(global-set-key (kbd "C-x g") 'magit-status)
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

