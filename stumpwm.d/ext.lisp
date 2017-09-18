;; -*-lisp-*-

(in-package :stumpwm)

(load "~/.quicklisp/dists/quicklisp/software/slime-v2.20/swank-loader.lisp")
(swank-loader:init)

;;;; modeline extension

;; modeline variables

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
(defvar my/size-l 8)

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
  (string-trim (format nil " ~c~c~c" #\newline #\return #\null) s))

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

(defun my/bg (color)
  (format nil "^(:bg \"~a\")" (my/color color)))

(defun my/fg (color)
  (format nil "^(:fg \"~a\")" (my/color color)))

(defvar my/agaric (format nil "~a~c" (my/fg :r) #\black_club_suit))

(defvar my/sep #\box_drawings_light_vertical)

(defun my/color-out (s color)
  (format nil "^[~a~a^]" (my/fg color) s))

(defun my/get-out (s &optional color)
  (format nil " ~a ~a"
          (if s
              (if color (my/color-out s color) s)
              (my/color-out "x" :c))
          (my/color-out my/sep :dim)))

;; getter helpers

(defun my/groups (active dim)
  (let* ((a (sort1 (screen-groups (current-screen)) '< :key 'group-number))
         (b (lambda (g)
              (let ((n (group-number g)))
                (if (= n (group-number (current-group)))
                    (format nil "^[~a~d^]" (my/fg active) n)
                    (if (or (group-windows g)
                            (< 1 (list-length (ignore-errors (group-frames g)))))
                        (princ-to-string n))))))
         (c (remove-if #'null (mapcar b a)))
         (out (reduce (lambda (x xs) (concat x " " xs)) c)))
    (format nil "~a~a" (my/fg dim) out)))

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
  (let* ((a "/sys/class/backlight/intel_backlight")
         (b (my/read (format nil "~a/brightness" a)))
         (c (my/read (format nil "~a/max_brightness" a))))
    `(,b . ,c)))

(defun my/get-vol ()
  (let* ((a (my/call "amixer sget Master | grep 'Front Left:'"))
         (b (my/extract ".*\\[([^\\]]+)%\\].*" a))
         (c (string= "off" (my/extract ".*\\[([^\\]]+)\\]" a))))
    `(,b . ,c)))

;; getters

(defun my/get-u ()
  (let* ((a (my/call "uptime"))
         (b (my/extract "up\\s+([^,]*)," a))
         (out (my/get-out b)))
    (setf *my/str-u* out)))

(defun my/get-t ()
  (let* ((a (format nil "date '+%a %b %d ~c %H:%M'" #\middle_dot))
         (b (my/chomp (my/call a)))
         (out (my/get-out b :gg)))
    (setf *my/str-t* out)))

(defun my/get-c ()
  (let* ((dev (format nil "/sys/class/hwmon/~a" my/cdev))
         (one (parse-integer (my/read (format nil "~a/temp1_input" dev))))
         (two (parse-integer (my/read (format nil "~a/temp2_input" dev))))
         (thr (parse-integer (my/read (format nil "~a/temp3_input" dev))))
         (avg (round (/ (/ (+ one two thr) 3) 1000)))
         (out (my/get-out (format nil "~d~c" avg #\degree_sign)
                          (if (< 88 avg) :c))))
    (setf *my/str-c* out)))

(defun my/get-m ()
  (let* ((a (cl-ppcre:scan-to-strings "Mem:.*" (my/call "free")))
         (tot (parse-integer (my/extract "\\s+([0-9]+).*" a)))
         (use (parse-integer (my/extract "\\s+[0-9]+\\s+([0-9]+).*" a)))
         (avg (round (* (/ use tot) 100)))
         (out (my/get-out (format nil "~d%" avg))))
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
         (out (my/get-out (format nil "/~a +~a" root data))))
    (setf *my/str-d* out)))

(defun my/get-n ()
  (let ((dev (my/get-ndev)))
    (when (not dev)
      (setf *my/str-n* (my/get-out nil))
      (return-from my/get-n))
    (let* ((path (concat (format nil "/sys/class/net/~a" dev)
                         "/statistics/~a_bytes"))
           (tx (parse-integer (my/read (format nil path "tx"))))
           (rx (parse-integer (my/read (format nil path "rx"))))
           (now (get-internal-real-time)))
      (when (not *my/last-n-time*)
        (setf *my/last-n-tx* tx
              *my/last-n-rx* rx
              *my/last-n-time* now
              *my/str-n* (my/get-out nil))
        (return-from my/get-n))
      (let* ((diff (- now *my/last-n-time*))
             (up (round (/ (- tx *my/last-n-tx*) diff)))
             (dn (round (/ (- rx *my/last-n-rx*) diff)))
             (a (format nil "~c~d ~c ~d~c"
                        #\black_up-pointing_triangle
                        up #\middle_dot dn
                        #\black_down-pointing_triangle))
             (out (my/get-out a)))
        (setf *my/last-n-tx* tx
              *my/last-n-rx* rx
              *my/last-n-time* now
              *my/str-n* out)))))

(defun my/get-p ()
  (let* ((a (my/call "iwgetid"))
         (b (my/extract "ESSID:\"(.*)\"" a))
         (c (if (> 20 (length b)) b
                (format nil "~a~c" (subseq b 0 19) #\horizontal_ellipsis)))
         (out (my/get-out c)))
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
         (out (my/get-out a)))
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
         (mute (cdr a))
         (out (my/get-out
               (if vol
                   (format nil "~c~a" #\black_right-pointing_triangle
                           (if mute "x" vol))))))
    (setf *my/str-v* out)))

(defun my/get-l ()
  (let* ((a (my/get-lum))
         (lum (parse-integer (car a)))
         (lim (parse-integer (cdr a)))
         (b (round (/ (* 100 lum) lim)))
         (out (my/get-out
               (format nil "~c~d%" #\circle_with_lower_half_black b))))
    (setf *my/str-l* out)))

(defun my/get-b ()
  (let* ((a (my/chomp (my/call "acpi")))
         (b (cl-ppcre:split ", " (second (cl-ppcre:split ": " a))))
         (stat (first b))
         (perc (string-right-trim "%" (second b)))
         (c (format nil "~a~a" perc
                    (cond
                      ((string= "Discharging" stat) ":")
                      ((string= "Charging" stat) #\high_voltage_sign)
                      ((string= "Full" stat) "")
                      (t "?"))))
         (out (my/get-out c)))
    (setf *my/str-b* out)))

;;;; command extension

;; command helpers

(defun my/clean-message (s)
  (message (cl-ppcre:regex-replace-all "~" s "~~")))

(defun my/notify-get (head body)
  (my/clean-message (format nil "~a: ~a" head body)))

;; askpass

(defcommand my/askpass (prompt) ((:string "prompt: "))
  "prompt for password"
  (read-one-line (current-screen) (format nil "~a " prompt) :password t))

;; exec

(define-stumpwm-type :my-shell (input prompt)
  (or (argument-pop-rest input)
      (completing-read (current-screen) prompt 'complete-program)))

(defcommand my/exec (cmd) ((:my-shell "bgin: "))
  "orphan program starter"
  (run-prog "/usr/local/bin/bgin" :args (list cmd) :wait nil))

;; hot

(defcommand my/hot-kbl () ()
  "hot command: kbl"
  (let* ((hsnt (search "+hsnt+" (my/call "setxkbmap -print")))
         (cmd (if hsnt "us" "hsnt"))
         (out (if hsnt "qwerty" "hsnt")))
    (my/call (format nil "setxkbmap -option ctrl:nocaps ~a" cmd))
    (my/acall "xset r rate 250 35")
    (my/notify-get "keyboard layout" out)))

(defcommand my/hot-lum (arg) ((:string "luminosity (-|+|*): "))
  "hot command: lum"
  (my/call (format nil "sudo 0lum ~a" arg))
  (let* ((a (my/get-lum))
         (lum (parse-integer (car a)))
         (lim (parse-integer (cdr a)))
         (out (format nil "~a~d%~a"
                      (cond
                        ((string= "-" arg) "down (")
                        ((string= "+" arg) "up ("))
                      (round (/ (* lum 100) lim))
                      (if (member arg '("-" "+") :test 'string=) ")"))))
    (my/notify-get "luminosity" out)))

(defcommand my/hot-rat (arg) ((:string "touchpad (tog|dwt|*): "))
  "hot command: rat"
  (let* ((dev "SynPS/2 Synaptics TouchPad")
         (prop (cond
                 ((string= "dwt" arg) "libinput Disable While Typing Enabled")
                 (t "Device Enabled"))) ; arg = "tog"
         (a (my/call "xinput list"))
         (id (my/extract (format nil "~a\\s+id=([0-9]+)" dev) a))
         (b (my/call (format nil "xinput list-props ~a | grep '~a ('" id prop)))
         (old (string= "1" (first (reverse (cl-ppcre:split "\\s+" b)))))
         (cmd (cond
                ((string= "dwt" arg)
                 (format nil "set-prop ~a '~a' ~d" id prop (if old 0 1)))
                (t ; arg = "tog"
                 (format nil "~a ~a" (if old "disable" "enable") id))))
         (out (cond
                ((string= "dwt" arg)
                 (format nil "DisableWhileTyping ~a" (if old "off" "on")))
                (t ; arg = "tog"
                 (if old "off" "on")))))
    (my/acall (format nil "xinput ~a" cmd))
    (my/notify-get "touchpad" out)))

(defcommand my/hot-shot (arg) ((:string "screenshot (s|w|*): "))
  "hot command: shot"
  (let* ((now (my/chomp (my/call "date +$B_NOW")))
         (dir (my/call "echo -n $HOME"))
         (file (format nil "~a/shot_~a-\\$wx\\$h.png" dir now))
         (opt (format nil "~a-q 100 -z"
                      (cond
                        ((string= "s" arg) "-s ")
                        ((string= "w" arg) "-u ")
                        (t ""))))
         (out (cond
                ((string= "s" arg) "selectshot")
                ((string= "w" arg) "windowshot")
                (t "screenshot"))))
    (funcall (if (string= arg "s") #'my/call #'my/acall)
             (format nil "scrot ~a ~a" opt file))
    (my/notify-get out (format nil "taken (~a)" dir))))

(defcommand my/hot-vol (arg) ((:string "volume (x|-|--|+|++|*): "))
  "hot command: vol"
  (let* ((x (my/call "amixer sget Master | grep 'Front Left:'"))
         (a (list (my/extract ".*\\[([^\\]]+)%\\].*" x)
                  (string= "off" (my/extract ".*\\[([^\\]]+)\\]" x))))
         (vol (parse-integer (car a)))
         (mute (cdr a))
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
         (s (format nil "~d%" n))
         (cmd (cond
                ((string= "x" arg)
                 (if mute "unmute" "mute"))
                ((member arg '("-" "--" "+" "++") :test 'string=)
                 (format nil "~a unmute" s))
                (t "unmute"))) ; arg = *
         (out (if (and (string= "x" arg) (not mute)) cmd s)))
    (if p (my/acall (format nil "amixer -q set Master ~a" cmd)))
    (my/notify-get "volume" out)))

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
           ((null which) (throw 'stumpwm::error "Abort."))
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

;; urgent

(defun my/urgent-message (target)
  (my/clean-message (format nil ">>> ~a" (window-title target))))

(add-hook *urgent-window-hook* #'my/urgent-message)

;;;; the actual extending

;; modeline

(defvar my/modeline
  (list my/agaric
        " "
        '(:eval (my/groups :kk :cc))
        " "
        (my/color-out my/sep :dim)
        (my/fg :gg)
        (my/color-out "%u" :c)
        " %v^>"
        (my/color-out my/sep :dim)
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

(setf
 *hidden-window-color* (my/fg :cc)
 *mode-line-background-color* (my/color :w)
 *mode-line-foreground-color* (my/color :cc)
 *mode-line-highlight-template* (concat "^[" (my/bg :dim) (my/fg :k) " ~a ^]")
 *screen-mode-line-format* my/modeline
 *window-info-format* (format nil "%n ~a ^>~a
~a %t
~a %c
~a %i"
(my/color-out "%m" :r)
(my/color-out "%wx%h" :gg)
(my/color-out "name:" :gg)
(my/color-out "class:" :gg)
(my/color-out "id:" :gg))
 *window-format* (format nil "^[~a%n^] %44t" (my/fg :y)))

;; hotkeys

(mapcar (lambda (x) (define-key *top-map* (kbd (car x)) (cdr x)))
        '(("XF86AudioMute"          . "my/hot-vol x")
          ("S-XF86AudioLowerVolume" . "my/hot-vol -")
          ("XF86AudioLowerVolume"   . "my/hot-vol --")
          ("S-XF86AudioRaiseVolume" . "my/hot-vol +")
          ("XF86AudioRaiseVolume"   . "my/hot-vol ++")
          ("XF86Search"             . "my/hot-rat dwt")
          ("XF86MonBrightnessDown"  . "my/hot-lum -")
          ("XF86MonBrightnessUp"    . "my/hot-lum +")
          ("XF86AudioRewind"        . "my/hot-lum -") ; planck
          ("XF86AudioForward"       . "my/hot-lum +") ; planck
          ("Print"                  . "my/hot-shot")
          ("S-Print"                . "my/hot-shot s")
          ("Sys_Req"                . "my/hot-shot s") ; laptop
          ("C-Print"                . "my/hot-shot w")
          ("XF86PowerOff"           . "my/power-lock")
          ("C-M-Delete"             . "my/power")
          ("C-M-BackSpace"          . "my/power")
          ("s-\\"                   . "my/hot-kbl")
          ("s-o"                    . "my/exec")))

(defvar *my/keymap-exchange*
  (let ((m (make-sparse-keymap)))
    (mapcar (lambda (x) (define-key m (kbd (car x)) (cdr x)))
            '(("h" . "exchange-direction left")
              ("j" . "exchange-direction down")
              ("k" . "exchange-direction up")
              ("l" . "exchange-direction right")))
    m))
(define-key *top-map* (kbd "s-x") '*my/keymap-exchange*)
