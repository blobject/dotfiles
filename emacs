(package-initialize)
(require 'flycheck)
(require 'dot-mode)

(custom-set-variables
 '(aw-keys (quote (104 115 110 116 114 105 101 97 111)))
 '(backup-directory-alist (quote ((".*" . "~/bak/emacs/"))))
 '(blink-cursor-mode nil)
 '(browse-url-browser-function (quote browse-url-generic))
 '(browse-url-generic-program "google-chrome-beta")
 '(column-number-mode t)
 '(company-dabbrev-downcase nil)
 '(company-dabbrev-ignore-case nil)
 '(company-idle-delay 0)
 '(compilation-message-face (quote default))
 '(counsel-ag-base-command "rg --color never --no-heading %s")
 '(counsel-find-file-ignore-regexp nil)
 '(counsel-mode t)
 '(create-lockfiles nil)
 '(css-indent-offset 2)
 '(custom-enabled-themes (quote (solarized-light)))
 '(custom-safe-themes (quote ("a8245b7cc985a0610d71f9852e9f2767ad1b852c2bdea6f4aadc12cce9c4d6d0" "c74e83f8aa4c78a121b52146eadb792c9facc5b1f02c917e3dbb454fca931223" "a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" "84d2f9eeb3f82d619ca4bfffe5f157282f4779732f48a5ac1484d94d5ff5b279" "b9e9ba5aeedcc5ba8be99f1cc9301f6679912910ff92fdf7980929c2fc83ab4d" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(default-tab-width 2 t)
 '(electric-indent-inhibit t t)
 '(electric-pair-mode t)
 '(face-font-family-alternatives (quote (("custom" "Source Code Pro" "NanumBarunGothic" "NSimSun" "Meiryo" "FreeMono"))))
 '(fringe-mode 0 nil (fringe))
 '(global-dot-mode t)
 '(global-hl-line-mode t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-buffer-choice t)
 '(initial-scratch-message "")
 '(isearch-lazy-highlight nil)
 '(ivy-mode 1)
 '(js-indent-level 2)
 '(magit-diff-use-overlays nil)
 '(menu-bar-mode nil)
 '(mouse-wheel-progressive-speed nil)
 '(mouse-wheel-scroll-amount (quote (1 ((shift) . 5) ((control) . 10))))
 '(neo-show-hidden-files t)
 '(neo-smart-open t)
 '(neo-theme (quote ascii))
 '(neo-window-width 20)
 '(org-hide-leading-stars t)
 '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "https://melpa.org/packages/"))))
 '(package-selected-packages (quote (company-racer racer pixie-mode slime yaml-mode ess lua-mode csharp-mode swift-mode ace-window auctex avy company ivy org dot-mode ripgrep solarized-theme smart-mode-line-powerline-theme syslog-mode flycheck-clojure flycheck-rust go-mode rust-mode web-mode smart-mode-line rainbow-delimiters paredit neotree multiple-cursors markdown-mode magit iy-go-to-char hlinum haskell-mode geiser flycheck expand-region counsel clojure-mode cider browse-kill-ring)))
 '(racer-cmd "~/.cargo/bin/racer")
 '(racer-rust-src-path "/usr/local/src/rust/src")
 '(read-quoted-char-radix 16)
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(show-trailing-whitespace t)
 '(sml/col-number-format "%1c")
 '(sml/line-number-format "%1l")
 '(sml/name-width 16)
 '(sml/shorten-modes nil)
 '(solarized-high-contrast-mode-line t)
 '(tab-stop-list (number-sequence 2 100 2))
 '(tab-width 2)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
 '(vc-annotate-background-mode nil)
 '(vc-follow-symlinks nil)
 '(web-mode-code-indent-offset 2)
 '(web-mode-css-indent-offset 2)
 '(web-mode-markup-indent-offset 2))

(custom-set-faces
 '(default ((t (:weight semi-bold :height 115 :family "custom"))))
 '(aw-background-face ((t (:foreground "#93a1a1"))))
 '(linum-highlight-face ((t (:background "#eee8d5" :foreground "#002b36"))))
 '(org-level-1 ((t (:inherit variable-pitch :height 1.0 :family "custom"))))
 '(org-level-2 ((t (:inherit variable-pitch :height 1.0 :family "custom"))))
 '(org-level-3 ((t (:inherit variable-pitch :height 1.0 :family "custom"))))
 '(org-level-4 ((t (:inherit variable-pitch :height 1.0 :family "custom"))))
 '(org-level-5 ((t (:inherit variable-pitch :family "custom"))))
 '(org-level-6 ((t (:inherit variable-pitch :family "custom"))))
 '(org-level-7 ((t (:inherit variable-pitch :family "custom"))))
 '(org-level-8 ((t (:inherit variable-pitch :family "custom"))))
 '(sml/line-number ((t (:weight bold))))
 '(sml/minor-modes ((t (:inherit sml/global :height 0.9))))
 '(sml/modes ((t (:inherit sml/global :weight bold :height 0.9)))))
; '(trailing-whitespace ((t (:background "#073642"))))

(add-hook 'find-file-hooks 'dot-mode-on)
(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'global-flycheck-mode)
(add-hook 'after-init-hook 'hlinum-activate)
(add-hook 'after-init-hook 'sml/setup)
(add-hook 'org-mode-hook (lambda () (visual-line-mode) (org-indent-mode)))
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'flycheck-mode-hook 'flycheck-rust-setup)
;(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
;(add-hook 'geiser-mode-hook 'enable-paredit-mode)
;(add-hook 'lisp-mode-hook 'enable-paredit-mode)
;(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'company-mode)
;(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'web-mode-hook (lambda ()
  (if (equal web-mode-content-type "javascript")
    (web-mode-set-content-type "jsx"))))

(add-to-list 'auto-mode-alist '("xonshrc" . python-mode))
(add-to-list 'auto-mode-alist '("^/var/log/" . syslog-mode))
(add-to-list 'auto-mode-alist '("\\.log$" . syslog-mode))
(add-to-list 'auto-mode-alist '("\\..?css$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))
(flycheck-add-mode 'javascript-eslint 'web-mode)

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
(global-set-key (kbd "C-x [") 'neotree-toggle)
(global-set-key (kbd "C-x /") 'my/toggle-selective-display)
(global-set-key (kbd "C-x 2") 'my/vsplit-last-buffer)
(global-set-key (kbd "C-x 3") 'my/hsplit-last-buffer)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-x o") 'ace-window)
(global-set-key (kbd "C-x y") 'browse-kill-ring)
(global-unset-key (kbd "C-x ]"))
(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "M-C-\\"))
(global-unset-key (kbd "<C-down-mouse-1>"))
(global-unset-key (kbd "<C-down-mouse-2>"))
(global-unset-key (kbd "<C-down-mouse-3>"))
(global-unset-key (kbd "<S-down-mouse-1>"))
(global-unset-key (kbd "<S-down-mouse-2>"))
(global-unset-key (kbd "<S-down-mouse-3>"))

(setq inferior-lisp-program "sbcl")
(load (expand-file-name "~/.quicklisp/slime-helper.el"))

(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))

(defun my/back-to-indentation-or-beginning ()
  "do what i mean when i go back to beginning"
  (interactive)
  (if (= (point) (progn (back-to-indentation) (point)))
    (beginning-of-line)))

(defun my/vsplit-last-buffer (prefix)
  "split window vertically and display last buffer"
  (interactive "p")
  (split-window-vertically)
  (other-window 1 nil)
  (if (= prefix 1) (switch-to-next-buffer)))

(defun my/hsplit-last-buffer (prefix)
  "split window horizontally and display last buffer"
  (interactive "p")
  (split-window-horizontally)
  (other-window 1 nil)
  (if (= prefix 1) (switch-to-next-buffer)))

(defun my/select-current-line ()
  "select current line"
  (interactive)
  (end-of-line)
  (set-mark (line-beginning-position)))

(defun my/open-next-line (arg)
  "open new line after current line"
  (interactive "p")
  (end-of-line)
  (open-line arg)
  (next-line 1)
  (indent-according-to-mode))

(defun my/open-previous-line (arg)
  "open new line before current line"
  (interactive "p")
  (beginning-of-line)
  (open-line arg)
  (indent-according-to-mode))

(defun my/toggle-selective-display (column)
  "fold code block"
  (interactive "p")
  (set-selective-display
    (if selective-display nil (or column 1))))
