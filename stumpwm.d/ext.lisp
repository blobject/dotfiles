;; -*-lisp-*-

(in-package :stumpwm)

(load "~/.quicklisp/dists/quicklisp/software/slime-v2.20/swank-loader.lisp")
(swank-loader:init)

;;;; modeline extension

;; modeline variables

(defvar my/agaric (concat "^(:fg \"" (my/color :r) "\")" '(#\black_club_suit)))
(defvar my/modeline-sep '(#\box_drawings_light_vertical))
(defvar *my/str-u* "") (defvar *my/next-u* 0)
(defvar *my/str-t* "") (defvar *my/next-t* 0)
(defvar *my/str-c* "") (defvar *my/next-c* 0)
(defvar *my/str-m* "") (defvar *my/next-m* 0)
(defvar *my/str-d* "") (defvar *my/next-d* 0)
(defvar *my/str-n* "") (defvar *my/next-n* 0)
(defvar *my/str-p* "") (defvar *my/next-p* 0)
(defvar *my/str-l* "") (defvar *my/next-l* 0)
(defvar *my/str-b* "") (defvar *my/next-b* 0)
(defvar *my/str-k* "") (defvar *my/next-k* 0)
(defvar *my/str-v* "") (defvar *my/next-v* 0)
(defvar *my/last-n-tx* 0)
(defvar *my/last-n-rx* 0)
(defvar *my/last-n-time* nil)
(defvar *my/put-setxkbmap* t)
(defvar *my/put-xset* nil)
(defvar *my/put-amixer* '())

;; operational + string + stream helpers

(defun my/read (path)
  (with-open-file (stream path) (read-line stream)))

(defun my/call (cmd)
  (run-shell-command cmd t))

(defun my/acall (cmd)
  (run-shell-command cmd))

(defmacro my/thread (name var fn)
  `(bt:make-thread (lambda () (setf ,var (,@fn))) :name ,name))

(defun my/chomp (s)
  (string-trim '(#\newline #\return #\null) s))

(defun my/extract (re s)
  (multiple-value-bind (match sub)
    (cl-ppcre:scan-to-strings re s)
    (if match (aref sub 0))))

(defun my/modeline-do (fn vstr vnext interval)
  (let ((now (get-universal-time)))
    (when (< now (symbol-value vnext))
      (return-from my/modeline-do (symbol-value vstr)))
    (set vnext (+ now interval)))
  (set vstr (funcall fn)))

;; styling helpers

(defun my/color-out (s color-in &optional color-out)
  (concat (format nil "^(:fg \"~a\")" color-in)
          s
          (format nil "^(:fg \"~a\")"
                  (or color-out (my/color :cc)))))

(defun my/modeline-out (s &optional color)
  (concat
   (format nil " ~a "
           (if (not s)
             (my/color-out "x" (my/color :c))
             (if color
               (my/color-out s color)
               s)))
   (my/color-out my/modeline-sep (my/color :dim))))

;; getter helpers

(defun my/groups (color-focus color-normal)
  (concat
   "^(:fg \"" color-normal "\")"
   (let* ((a (sort1 (screen-groups (current-screen)) '< :key 'group-number))
          (b (mapcar (lambda (g)
                       (let ((n (group-number g)))
                         (if (= n (group-number (current-group)))
                             (format nil "^(:fg \"~a\")~a^(:fg \"~a\")"
                                     color-focus n color-normal)
                             (if (group-windows g)
                                 (princ-to-string n)))))
                     a))
          (out (remove-if #'null b)))
     (reduce (lambda (head tail) (concat head " " tail)) out))))

(defvar my/cdev
  (let ((a (directory "/sys/class/hwmon/*/temp1_max")))
    (if a (funcall (compose #'car
                            #'last
                            #'pathname-directory
                            #'car)
                   a))))

(defun my/get-ndev ()
  (let ((a (directory "/sys/class/net/*/wireless")))
    (if a (funcall (compose #'second
                            #'reverse
                            #'pathname-directory
                            #'car)
                   a))))

(defun my/get-lum ()
  (let* ((a "/sys/class/backlight/intel_backlight/")
         (b (my/read (concat a "max_brightness")))
         (c (my/read (concat a "brightness"))))
    (list b c)))

(defun my/get-vol ()
  (let* ((a (my/call "amixer sget Master | grep 'Front Left:'"))
         (b (my/extract ".*\\[([^\\]]+)%\\].*" a))
         (c (string= "off" (my/extract ".*\\[([^\\]]+)\\]" a))))
    (list b c)))

;; getters

(defun my/get-u ()
  (let* ((a (my/call "uptime"))
         (b (my/extract "up\\s+([^,]*)," a))
         (out (my/modeline-out b)))
    (setf *my/str-u* out)))

(defun my/get-t ()
  (let* ((a (concat "date '+%a %b %d " '(#\middle_dot) " %H:%M'"))
         (b (my/chomp (my/call a)))
         (out (my/modeline-out b (my/color :gg))))
    (setf *my/str-t* out)))

(defun my/get-c ()
  (let* ((dev (concat "/sys/class/hwmon/" my/cdev))
         (one (parse-integer (my/read (concat dev "/temp1_input"))))
         (two (parse-integer (my/read (concat dev "/temp2_input"))))
         (thr (parse-integer (my/read (concat dev "/temp3_input"))))
         (avg (round (/ (/ (+ one two thr) 3) 1000)))
         (out (my/modeline-out (concat (princ-to-string avg) '(#\degree_sign))
                               (if (< 88 avg) (my/color :c)))))
    (setf *my/str-c* out)))

(defun my/get-m ()
  (let* ((a (cl-ppcre:scan-to-strings "Mem:.*" (my/call "free")))
         (tot (parse-integer (my/extract "\\s+([0-9]+).*" a)))
         (use (parse-integer (my/extract "\\s+[0-9]+\\s+([0-9]+).*" a)))
         (avg (round (* (/ use tot) 100)))
         (out (my/modeline-out (concat (princ-to-string avg) "%"))))
    (setf *my/str-m* out)))

(defun my/get-d ()
  (let* ((get (lambda (s)
                (string-right-trim
                 "%" (second (reverse (cl-ppcre:split "\\s+" s))))))
         (a (my/call "df"))
         (b (cl-ppcre:scan-to-strings "/dev/nvme0n1p2.*" a))
         (c (cl-ppcre:scan-to-strings "/dev/nvme0n1p3.*" a))
         (root (funcall get b))
         (data (funcall get c))
         (out (my/modeline-out (concat "/" root " +" data))))
    (setf *my/str-d* out)))

(defun my/get-n ()
  (let ((n (my/get-ndev)))
    (when (not n)
      (setf *my/str-n* (my/modeline-out nil))
      (return-from my/get-n))
    (let* ((dev (concat "/sys/class/net/" n))
           (tx (parse-integer (my/read (concat dev "/statistics/tx_bytes"))))
           (rx (parse-integer (my/read (concat dev "/statistics/rx_bytes"))))
           (now (get-internal-real-time)))
      (when (not *my/last-n-time*)
        (setf *my/last-n-tx* tx
              *my/last-n-rx* rx
              *my/last-n-time* now
              *my/str-n* (my/modeline-out nil))
        (return-from my/get-n))
      (let* ((diff (- now *my/last-n-time*))
             (up (round (/ (- tx *my/last-n-tx*) diff)))
             (dn (round (/ (- rx *my/last-n-rx*) diff)))
             (a (concat '(#\black_up-pointing_triangle)
                        (princ-to-string up)
                        " " '(#\middle_dot) " "
                        (princ-to-string dn)
                        '(#\black_down-pointing_triangle)))
             (out (my/modeline-out a)))
        (print tx)
        (setf *my/last-n-tx* tx
              *my/last-n-rx* rx
              *my/last-n-time* now
              *my/str-n* out)))))

(defun my/get-p ()
  (let* ((a (my/call "iwgetid"))
         (b (my/extract "ESSID:\"(.*)\"" a))
         (c (if (> 20 (length b)) b
                (concat (subseq b 0 19) '(#\horizontal_ellipsis))))
         (out (my/modeline-out c)))
    (setf *my/str-p* out)))

(defun my/get-k ()
  ; sep 2017 (near stumpwm-88c4e90d)
  ; - https://github.com/stumpwm/stumpwm/issues/246
  ; - looks like the `bt:make-thread` must happen on this level (hence macro)
  (my/thread "my-setxkbmap-thread"
             *my/put-setxkbmap*
             (search "+hsnt+" (my/call "setxkbmap -print")))
  (my/thread "my-xset-thread"
             *my/put-xset*
             (let* ((a (my/call "xset q"))
                    (b (cl-ppcre:scan-to-strings "00: C.*" a))
                    (c (fourth (cl-ppcre:split "\\s+" b))))
               (string= "on" c)))
  (let* ((hsnt *my/put-setxkbmap*)
         (caps *my/put-xset*)
         (a (funcall (if caps #'string-upcase #'identity)
                     (if hsnt "h" "q")))
         (out (my/modeline-out a)))
    (setf *my/str-k* out)))

(defun my/get-v ()
  ; sep 2017 (near stumpwm-88c4e90d)
  ; - https://github.com/stumpwm/stumpwm/issues/246
  ; - looks like the `bt:make-thread` must happen on this level (hence macro)
  (my/thread "my-amixer-thread"
             *my/put-amixer*
             (my/get-vol))
  (let* ((a *my/put-amixer*)
         (vol (car a))
         (mute (cadr a))
         (out (my/modeline-out
               (if vol
                   (concat '(#\black_right-pointing_triangle)
                           (if mute "x" vol))))))
    (setf *my/str-v* out)))

(defun my/get-l ()
  (let* ((a (my/get-lum))
         (out (my/modeline-out (concat (cadr a) "/" (car a)))))
    (setf *my/str-l* out)))

(defun my/get-b ()
  (let* ((a (my/chomp (my/call "acpi")))
         (b (cl-ppcre:split ", " (cadr (cl-ppcre:split ": " a))))
         (stat (car b))
         (perc (string-right-trim "%" (cadr b)))
         (c (concat perc (cond
                           ((string= "Discharging" stat) ":")
                           ((string= "Charging" stat) "⚡")
                           ((string= "Full" stat) "")
                           (t "?"))))
         (out (my/modeline-out c)))
    (setf *my/str-b* out)))

;; the actual modeline

(defvar my/modeline
  (list my/agaric
        " "
        '(:eval (my/groups (my/color :kk) (my/color :cc)))
        " "
        (my/color-out my/modeline-sep (my/color :dim))
        (my/color-out "%u" (my/color :c) (my/color :g))
        " %v^>"
        (my/color-out my/modeline-sep (my/color :dim))
        '(:eval (my/modeline-do #'my/get-u '*my/str-u* '*my/next-u* 14))
        '(:eval (my/modeline-do #'my/get-t '*my/str-t* '*my/next-t*  9))
        '(:eval (my/modeline-do #'my/get-c '*my/str-c* '*my/next-c*  1))
        '(:eval (my/modeline-do #'my/get-m '*my/str-m* '*my/next-m* 14))
        '(:eval (my/modeline-do #'my/get-d '*my/str-d* '*my/next-d* 14))
        '(:eval (my/modeline-do #'my/get-n '*my/str-n* '*my/next-n*  1))
        '(:eval (my/modeline-do #'my/get-p '*my/str-p* '*my/next-p* 14))
        '(:eval (my/modeline-do #'my/get-l '*my/str-l* '*my/next-l*  4))
        '(:eval (my/modeline-do #'my/get-v '*my/str-v* '*my/next-v*  2))
        '(:eval (my/modeline-do #'my/get-k '*my/str-k* '*my/next-k*  2))
        '(:eval (my/modeline-do #'my/get-b '*my/str-b* '*my/next-b*  4))
        " %T"))

;;;; command extension

;; command helpers

(defun my/notify (head body &optional urg)
  (my/acall (concat "notify-send "
                    "-u " (or urg "low")
                    " '" head "' '" body "'")))

;; askpass

(defcommand my/askpass (prompt) ((:string "prompt: "))
  "prompt for password"
  (read-one-line (current-screen) (concat prompt " ") :password t))

;; hot

(defcommand my/hot-kbl () ()
  "hot command: kbl"
  (let* ((hsnt (search "+hsnt+" (my/call "setxkbmap -print")))
         (cmd (if hsnt "us" "hsnt"))
         (out (if hsnt "qwerty" "hsnt")))
    (my/call (concat "setxkbmap -option ctrl:nocaps " cmd))
    (my/acall (concat "xset r rate 250 35"))
    (my/notify "keyboard layout" out)))

(defcommand my/hot-lum (arg) ((:string "luminosity (-|+|*): "))
  "hot command: lum"
  (my/call (concat "sudo 0lum " arg))
  (let* ((a (my/get-lum))
         (lum (parse-integer (cadr a)))
         (lim (parse-integer (car a)))
         (out (concat (cond
                        ((string= "-" arg) "down (")
                        ((string= "+" arg) "up ("))
                      (princ-to-string (round (/ (* lum 100) lim)))
                      "%"
                      (if (member arg '("-" "+") :test 'string=) ")"))))
    (my/notify "luminosity" out)))

(defcommand my/hot-rat (arg) ((:string "touchpad (tog|dwt|*): "))
  "hot command: rat"
  (let* ((dev "SynPS/2 Synaptics TouchPad")
         (prop (cond
                 ((string= "dwt" arg) "libinput Disable While Typing Enabled")
                 (t "Device Enabled"))) ; arg = "tog"
         (a (my/call "xinput list"))
         (id (my/extract (concat dev "\\s+id=([0-9]+)") a))
         (b (my/call (concat "xinput list-props " id " | grep '" prop " ('")))
         (old (string= "1" (car (reverse (cl-ppcre:split "\\s+" b)))))
         (cmd (cond
                ((string= "dwt" arg)
                 (concat "set-prop " id " '" prop "' " (if old "0" "1")))
                (t ; arg = "tog"
                 (concat (if old "disable " "enable ") id))))
         (out (cond
                ((string= "dwt" arg)
                 (concat "DisableWhileTyping " (if old "off" "on")))
                (t ; arg = "tog"
                 (if old "off" "on")))))
    (my/acall (concat "xinput " cmd))
    (my/notify "touchpad" out)))

(defcommand my/hot-shot (arg) ((:string "screenshot (s|w|*): "))
  "hot command: shot"
  (let* ((now (my/chomp (my/call "date +$B_NOW")))
         (dir (my/call "echo -n $HOME"))
         (file (concat dir "/shot_" now "-\\$wx\\$h.png"))
         (opt (concat (cond
                        ((string= "s" arg) "-s ")
                        ((string= "w" arg) "-u ")
                        (t ""))
                      "-q 100 -z "))
         (out (cond
                ((string= "s" arg) "selectshot")
                ((string= "w" arg) "windowshot")
                (t "screenshot"))))
    (my/acall (concat "scrot " opt file))
    (my/notify out (concat "taken (" dir ")"))))

(defcommand my/hot-vol (arg) ((:string "volume (x|-|--|+|++|*): "))
  "hot command: vol"
  (let* ((x (my/call "amixer sget Master | grep 'Front Left:'"))
         (a (list (my/extract ".*\\[([^\\]]+)%\\].*" x)
                  (string= "off" (my/extract ".*\\[([^\\]]+)\\]" x))))
         (vol (parse-integer (car a)))
         (mute (cadr a))
         (c (cond
              ((string= "-"  arg) (- vol 1))
              ((string= "--" arg) (- vol 5))
              ((string= "+"  arg) (+ vol 1))
              ((string= "++" arg) (+ vol 5))
              (t vol))) ; arg = "x", *
         (n (cond
              ((member arg '("-" "--") :test 'string=) (if (> 0 c) 0 c))
              ((member arg '("+" "++") :test 'string=) (if (< 100 c) 100 c))
              (t c))) ; arg = "x", *
         (p (cond
              ((member arg '("-" "--") :test 'string=) (< 0 vol))
              ((member arg '("+" "++") :test 'string=) (> 100 vol))
              (t t))) ; arg = "x", *
         (s (concat (princ-to-string n) "%"))
         (cmd (cond
                ((string= "x" arg)
                 (if mute "unmute" "mute"))
                ((member arg '("-" "--" "+" "++") :test 'string=)
                 (concat s " unmute"))
                (t "unmute"))) ; arg = *
         (out (if (and (string= "x" arg) (not mute)) cmd s)))
    (if p (my/acall (concat "amixer -q set Master " cmd)))
    (my/notify "volume" out)))

;; power

(defvar my/menu-power
  '(("lock" "my/power-lock")
    ("quit" "my/power-quit")
    ("reboot" "my/power-reboot")
    ("halt" "my/power-halt")))

(defun my/menu (menu)
  (labels
    ((pick (options)
       (let ((which (select-from-menu (current-screen) options "")))
         (cond
           ((null which) (throw 'stumpwm::error "cancel."))
           ((stringp (second which)) (second which))
           (t (pick (cdr which)))))))
    (run-commands (pick menu))))

(defun my/power-stop ()
  (mapcar #'my/acall
          '("alsactl --file $HOME/.config/asound.state store"
            "emacsclient -e '(kill-emacs)'"
            "for i in $(ps ax | grep -- '-zsh' | grep 'Ss+' | grep pts | awk '{print $1}'); do kill -9 $i; done"))
  (my/call "0browsertmp"))

(defcommand my/power-lock () ()
  "power menu: lock"
  (my/acall "slock"))

(defcommand my/power-quit () ()
  "power menu: lock"
  (my/power-stop)
  (quit))

(defcommand my/power-reboot () ()
  "power menu: lock"
  (my/power-stop)
  (my/acall "sudo reboot"))

(defcommand my/power-halt () ()
  "power menu: lock"
  (my/power-stop)
  (my/acall "sudo halt"))

(defcommand my/power () ()
  "power menu"
  (my/menu my/menu-power))

;; swank

(defcommand my/swank () ()
  "start swank"
  (swank:create-server :port 4006
                       :style swank:*communication-style*
                       :dont-close t)
  (message "Starting swank. M-x slime-connect RET RET. \"(in-package :stumpwm)\"."))

;;;; the actual extending

;; modeline

(setf
 ; order matters
 *group-format* "%n"
 *mode-line-highlight-template* (concat "^(:fg \"" (my/color :kk) "\")"
                                        "~a"
                                        "^(:fg \"" (my/color :g) "\")")
 *hidden-window-color* (format nil "^(:fg \"~a\")" (my/color :cc))
 *window-format* "%8c: %17t"
 *screen-mode-line-format* my/modeline
 *mode-line-foreground-color* (my/color :cc)
 *mode-line-background-color* (my/color :w)
 )

;; hotkeys

(mapcar (lambda (x) (define-key *top-map* (kbd (car x)) (cadr x)))
        '(("XF86AudioMute"          "my/hot-vol x")
          ("S-XF86AudioLowerVolume" "my/hot-vol -")
          ("XF86AudioLowerVolume"   "my/hot-vol --")
          ("S-XF86AudioRaiseVolume" "my/hot-vol +")
          ("XF86AudioRaiseVolume"   "my/hot-vol ++")
          ("XF86Search"             "my/hot-rat dwt")
          ("XF86MonBrightnessDown"  "my/hot-lum -")
          ("XF86MonBrightnessUp"    "my/hot-lum +")
          ("XF86AudioRewind"        "my/hot-lum -")
          ("XF86AudioForward"       "my/hot-lum +")
          ("Print"                  "my/hot-shot")
          ("S-Print"                "my/hot-shot s")
          ("C-Print"                "my/hot-shot w")
          ("XF86PowerOff"           "my/power-lock")
          ("C-M-BackSpace"          "my/power")
          ("C-M-Delete"             "my/power")
          ("s-\\"                   "my/hot-kbl")
          ))
