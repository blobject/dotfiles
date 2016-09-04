(package-initialize)
; ace-window
; angular-mode
; auctex
; avy
; browse-kill-ring
; company
; counsel
; evil
; expand-region
; flycheck
; haskell-mode
; hlinum
; ivy
; iy-go-to-char
; magit
; markdown-mode
; multiple-cursors
; neotree
; org
; paredit
; rainbow-delimiters
; smart-mode-line
; solarized-theme
; web-mode

(custom-set-variables
  '(auto-save-default nil)
  '(aw-keys (quote (104 115 110 116 114 105 101 97 111)))
  '(backup-directory-alist (quote ((".*" . "~/bak/emacs/"))))
  '(blink-cursor-mode nil)
  '(column-number-mode t)
  '(company-idle-delay 0)
  '(create-lockfiles nil)
  '(css-indent-offset 2)
  '(custom-enabled-themes (quote (solarized-dark)))
  '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
  '(default-tab-width 2 t)
  '(electric-indent-inhibit t t)
  '(electric-pair-mode t)
  '(face-font-family-alternatives (quote (("consolas" "seoul namsan" "nsimsun" "meiryo"))))
  '(fringe-mode 0 nil (fringe))
  '(indent-tabs-mode nil)
  '(inhibit-startup-screen t)
  '(initial-buffer-choice t)
  '(initial-scratch-message "")
  '(isearch-lazy-highlight nil)
  '(ivy-mode t)
  '(menu-bar-mode nil)
  '(mouse-wheel-scroll-amount (quote (1 ((shift) . 5) ((control) . 10))))
  '(mouse-wheel-progressive-speed nil)
  '(neo-show-hidden-files t)
  '(neo-smart-open t)
  '(neo-theme (quote ascii))
  '(neo-window-width 20)
  '(org-agenda-files (quote ("~/todo.org")))
  '(org-hide-leading-stars t)
  '(package-archives (quote (("gnu" . "http://elpa.gnu.org/packages/") ("melpa" . "https://melpa.org/packages/"))))
  '(read-quoted-char-radix 16)
  '(scroll-bar-mode nil)
  '(show-paren-mode t)
  '(show-trailing-whitespace t)
  '(sml/no-confirm-load-theme t)
  '(tab-stop-list (number-sequence 2 100 2))
  '(tab-width 2)
  '(tool-bar-mode nil)
  '(uniquify-buffer-name-style (quote post-forward) nil (uniquify))
  '(vc-follow-symlinks nil)
  '(web-mode-markup-indent-offset 2)
  '(web-mode-code-indent-offset 2)
  '(web-mode-css-indent-offset 2))

(custom-set-faces
  '(default ((t (:family "monospace" :height 105))))
  '(fringe ((t (:background "#073642" :foreground "#073642"))))
  '(linum ((t (:background "#002b36" :foreground "#073642" :weight bold))))
  '(linum-highlight-face ((t (:background "#002b36" :foreground "#93a1a1" :weight bold))))
  '(mode-line-highlight ((t (:background "#002b36"))))
  '(org-document-title ((t (:foreground "#93a1a1" :weight bold :height 1.0))))
  '(org-level-1 ((t (:inherit variable-pitch :foreground "#cb4b16" :height 1.0 :family "monospace"))))
  '(org-level-2 ((t (:inherit variable-pitch :foreground "#859900" :height 1.0 :family "monospace"))))
  '(org-level-3 ((t (:inherit variable-pitch :foreground "#268bd2" :height 1.0 :family "monospace"))))
  '(org-level-4 ((t (:inherit variable-pitch :foreground "#b58900" :height 1.0 :family "monospace"))))
  '(org-level-5 ((t (:inherit variable-pitch :foreground "#2aa198" :family "monospace"))))
  '(org-level-6 ((t (:inherit variable-pitch :foreground "#859900" :family "monospace"))))
  '(org-level-7 ((t (:inherit variable-pitch :foreground "#dc322f" :family "monospace"))))
  '(org-level-8 ((t (:inherit variable-pitch :foreground "#268bd2" :family "monospace"))))
  '(tooltip ((t (:background "#93a1a1" :foreground "#002b36" :family "monospace"))))
  '(trailing-whitespace ((t (:background "#073642"))))
  '(vertical-border ((t (:foreground "#073642")))))

(add-hook 'after-init-hook 'global-company-mode)
(add-hook 'after-init-hook 'global-flycheck-mode)
(add-hook 'after-init-hook 'hlinum-activate)
(add-hook 'after-init-hook 'sml/setup)
(add-hook 'org-mode-hook (lambda () (visual-line-mode) (org-indent-mode)))
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-mode-hook 'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook 'enable-paredit-mode)
(add-hook 'scheme-mode-hook 'enable-paredit-mode)
(add-hook 'web-mode-hook (lambda ()
  (if (equal web-mode-content-type "javascript")
    (web-mode-set-content-type "jsx"))))

(add-to-list 'auto-mode-alist '("\\..?css$" . css-mode))
(add-to-list 'auto-mode-alist '("\\.html?$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl$" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx?$" . web-mode))

(fset 'yes-or-no-p 'y-or-n-p)
(global-set-key (kbd "M-n") (lambda () (interactive) (scroll-up 1)))
(global-set-key (kbd "M-p") (lambda () (interactive) (scroll-down 1)))
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-,") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "C-.") 'er/expand-region)
(global-set-key (kbd "C-;") 'my/select-current-line)
(global-set-key (kbd "C-:") 'avy-goto-char-timer)
(global-set-key (kbd "C-'") 'iy-go-up-to-char)
(global-set-key (kbd "C-\"") 'iy-go-to-char-backward)
(global-set-key (kbd "C-a") 'my/back-to-indentation-or-beginning)
(global-set-key (kbd "C-o") 'my/open-next-line)
(global-set-key (kbd "M-o") 'my/open-previous-line)
(global-set-key (kbd "C-x [") 'neotree-toggle)
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

(flycheck-add-mode 'javascript-eslint 'web-mode)
((nil . ((eval . (progn
  (add-to-list 'exec-path
    (concat (locate-dominating-file default-directory ".dir-locals.el")
            "node_modules/.bin/")))))))

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

(defadvice web-mode-highlight-part (around tweak-jsx activate)
  (if (equal web-mode-content-type "jsx")
    (let ((web-mode-enable-part-face nil))
      ad-do-it)
    ad-do-it))
