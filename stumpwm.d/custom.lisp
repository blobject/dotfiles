(defun my/modeline-w () "w")
(defun my/modeline-u () "u")
(defun my/modeline-t () "t")
(defun my/modeline-c () "c")
(defun my/modeline-m () "m")
(defun my/modeline-d () "d")
(defun my/modeline-n () "n")
(defun my/modeline-p () "p")
(defun my/modeline-k () "k")
(defun my/modeline-v () "v")
(defun my/modeline-l () "l")
(defun my/modeline-b () "b")

(defvar my/modeline
  (list "%g  "
        "%v  "
        "(%N)  "
        "^> "
        '(:eval (my/modeline-w))
        '(:eval (my/modeline-u))
        '(:eval (my/modeline-t))
        '(:eval (my/modeline-c))
        '(:eval (my/modeline-m))
        '(:eval (my/modeline-d))
        '(:eval (my/modeline-n))
        '(:eval (my/modeline-p))
        '(:eval (my/modeline-k))
        '(:eval (my/modeline-v))
        '(:eval (my/modeline-l))
        '(:eval (my/modeline-b))
        " %T"))

;    (defparameter *app-menu* '(("INTERNET"
;                              ;; sub menu
;                        ("Firefox" "firefox")
;                        ("Skype" "skype"))
;                   ("FUN"
;                    ;; sub menu
;                        ("option 2" "xlogo")
;                        ("GnuChess" "xboard"))
;                       ("WORK"
;                    ;;submenu
;                    ("OpenOffice.org" "openoffice"))
;                   ("GRAPHICS"
;                    ;;submenu
;                    ("GIMP" "gimp"))
;                    ("K3B" "k3b")))
;
;    (define-stumpwm-command "mymenu" ()
;      (labels ((pick (options)
;                 (let ((selection (stumpwm::select-from-menu (current-screen) options "")))
;                   (cond
;                     ((null selection)
;                      (throw 'stumpwm::error "Abort."))
;                     ((stringp (second selection))
;                      (second selection))
;                     (t
;                      (pick (cdr selection)))))))
;        (let ((choice (pick *app-menu*)))
;          (run-shell-command choice))))

(defcommand my/password (prompt) ((:string "prompt: "))
  "prompt for password"
  (read-one-line (current-screen) prompt :password t))

(defcommand my/swank () ()
  "start swank"
  (swank:create-server :port 4006
                       :style swank:*communication-style*
                       :dont-close t)
  (echo-string (current-screen)
               "Starting swank. M-x slime-connect RET RET -> (in-package stumpwm)"))
