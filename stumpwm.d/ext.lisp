;; -*-lisp-*-

(in-package :stumpwm)

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
(defvar *my/alert-c* nil)
(defvar *my/alert-m* nil)
(defvar *my/alert-d* nil)
(defvar *my/put-setxkbmap* t)
(defvar *my/put-xset* nil)
(defvar *my/put-amixer* '())

;; operational + string + stream helpers

(defmacro my/read (path)
  `(with-open-file (stream ,path) (read-line stream)))

(defun my/call (cmd)
  (run-shell-command cmd t))

(defun my/acall (cmd)
  (run-shell-command cmd))

(defun my/run (cmd)
  (run-prog "/usr/local/bin/bgin" :args (cl-ppcre:split " " cmd) :wait nil))

(defmacro my/thread (name var fn)
  `(bt:make-thread (lambda () (setf ,var (,@fn))) :name ,name))

(defun my/in? (x l)
  (cond
    ((stringp l) ; l: str
     (if (listp x) ; x: list of str
         (progn
           (mapcar (lambda (i) (if (search i l) (return-from my/in? t))) x)
           nil)
         (if (search x l) t nil)))
    ((keywordp x) ; x: kw, l: list of kw
     (if (member x l) t nil))
    ((stringp x) ; x: str, l: list of str
     (if (member x l :test #'equal) t nil))
    ((listp x) ; x: list of _, l: list of _
     (mapcar (lambda (i) (if (cond
                               ((stringp i) (member i l :test #'equal))
                               (t (member i l)))
                             (return-from my/in? t)))
             x)
     nil)
    (t (if (member x l) t nil))))

(defmacro my/chomp (s)
  `(string-trim (format nil " ~c~c~c" #\newline #\return #\null) ,s))

(defun my/extract (re s)
  (multiple-value-bind (match sub)
    (cl-ppcre:scan-to-strings re s)
    (if match (aref sub 0))))

(defun my/modeline-do (fn fk vstr vnext interval)
  (let ((now (get-universal-time)))
    (when (< now (symbol-value vnext))
      (return-from my/modeline-do (symbol-value vstr)))
    (set vnext (+ now interval)))
  (set vstr (funcall fn fk)))

;; styling helpers

(defmacro my/bg (color)
  `(format nil "^(:bg \"~a\")" (my/color ,color)))

(defmacro my/fg (color)
  `(format nil "^(:fg \"~a\")" (my/color ,color)))

(defmacro my/clout (s color)
  `(format nil "^[~a~a^]" (my/fg ,color) ,s))

(defun my/out (s &optional color)
  (concat (if s
              (if color (my/clout s color) s)
              (my/clout "x" :h))
          " "))

(defun my/char (key)
  (case key
    (:agaric (format nil "~a~c" (my/fg :r) #\black_club_suit))
    (:t #\uf017) ; clock
    (:c #\uf1b2) ; cube
    (:n #\uf1eb) ; wifi
    (:l #\uf185) ; sun
    (:v #\uf028) ; volume
    (:k #\uf11c) ; keyboard
    (:bchrg #\uf0e7) ; bolt
    (:bfull #\uf240) ; battery full
    (:bpart #\uf243) ; battery quarter
    (:bnone #\uf244) ; battery empty
    ))

(defun my/sep (key &optional s color)
  (case key
    (:icon (format nil " ^[~a~a^] "
                   (if color (my/fg color) (my/fg :y))
                   (if (keywordp s)
                       (format nil "^(:font 1)~c^(:font 0)" (my/char s))
                       s)))
    (:dot (format nil "~c " #\middle_dot))
    (t " ")))

;; getter helpers

(defvar my/dev-c
  (let ((a (directory "/sys/class/hwmon/*/temp1_max")))
    (if a (funcall (compose #'car
                            #'last
                            #'pathname-directory
                            #'car)
                   a))))

(defun my/gut (key)
  (case key

    (:dev-n ; net device
     (let ((a (directory "/sys/class/net/*/wireless")))
       (if a (funcall (compose #'second
                               #'reverse
                               #'pathname-directory
                               #'car)
                      a))))

    (:lum ; luminosity
     (let* ((a "/sys/class/backlight/intel_backlight")
            (b (my/read (concat a "/brightness")))
            (c (my/read (concat a "/max_brightness"))))
       (cons b c)))

    (:vol ; volume
     (let* ((a (my/call "amixer sget Master | grep 'Front Left:'"))
            (b (my/extract ".*\\[([^\\]]+)%\\].*" a))
            (c (equal "off" (my/extract ".*\\[([^\\]]+)\\]" a))))
       (cons b c)))))

;; getters

(defun my/get (key)
  (case key

    (:u ; uptime
     (let* ((a (my/call "uptime"))
            (out (my/out (my/extract "up\\s+([^,]*)," a))))
       (setf *my/str-u* out)))

    (:t ; time
     (let* ((a (format nil "date '+%a %b %d, %H:%M'")) ; #\middle_dot doesn't work
            (out (my/out (my/chomp (my/call a)) :gg)))
       (setf *my/str-t* out)))

    (:c ; cpu
     (let* ((dev (concat "/sys/class/hwmon/" my/dev-c))
            (a (parse-integer (my/read (concat dev "/temp1_input"))))
            (b (parse-integer (my/read (concat dev "/temp2_input"))))
            (c (parse-integer (my/read (concat dev "/temp3_input"))))
            (cpu (round (/ (/ (+ a b c) 3) 1000)))
            (alert (< 88 cpu))
            (out (my/out (format nil "~d~c" cpu #\degree_sign)
                         (if alert :h))))
       (setf *my/alert-c* alert)
       (setf *my/str-c* out)))

    (:m ; memory
     (let* ((a (cl-ppcre:scan-to-strings "Mem:.*" (my/call "free")))
            (b (parse-integer (my/extract "\\s+([0-9]+).*" a)))
            (c (parse-integer (my/extract "\\s+[0-9]+\\s+([0-9]+).*" a)))
            (mem (round (* (/ c b) 100)))
            (alert (< 64 mem))
            (out (my/out (format nil "~d%%" mem)
                         (if alert :h))))
       (setf *my/alert-m* alert)
       (setf *my/str-m* out)))

    (:d ; disk
     (flet ((perc (s)
              (string-right-trim
               "%" (second (reverse (cl-ppcre:split "\\s+" s))))))
       (let* ((a (my/call "df"))
              (b (cl-ppcre:scan-to-strings ".* /" a))
              (c (cl-ppcre:scan-to-strings ".* /data" a))
              (r (perc b))
              (d (perc c))
              (rr (concat "/" r))
              (dd (concat "+" d))
              (alert-r (< 98 (parse-integer r)))
              (alert-d (< 98 (parse-integer d)))
              (root (if alert-r (my/clout rr :h) rr))
              (data (if alert-d (my/clout dd :h) dd))
              (out (my/out (concat root " " data))))
         (setf *my/alert-d* (or alert-r alert-d))
         (setf *my/str-d* out))))

    (:n ; net
     (let ((dev (my/gut :dev-n)))
       (when (not dev)
         (setf *my/str-n* (my/out nil))
         (return-from my/get))
       (let* ((path (concat (format nil "/sys/class/net/~a" dev)
                            "/statistics/~a_bytes"))
              (tx (parse-integer (my/read (format nil path "tx"))))
              (rx (parse-integer (my/read (format nil path "rx"))))
              (now (get-internal-real-time)))
         (when (not *my/last-n-time*)
           (setf *my/last-n-tx* tx
                 *my/last-n-rx* rx
                 *my/last-n-time* now
                 *my/str-n* (my/out nil))
           (return-from my/get))
         (let* ((diff (- now *my/last-n-time*))
                (up (round (/ (- tx *my/last-n-tx*) diff)))
                (dn (round (/ (- rx *my/last-n-rx*) diff)))
                (out (my/out (format nil "~c~d ~c ~d~c"
                                     #\black_down-pointing_triangle
                                     dn #\middle_dot up
                                     #\black_up-pointing_triangle))))
           (setf *my/last-n-tx* tx
                 *my/last-n-rx* rx
                 *my/last-n-time* now
                 *my/str-n* out)))))

    (:p ; point
     (let* ((a (my/call "iwgetid"))
            (b (my/extract "ESSID:\"(.*)\"" a))
            (out (my/out (if (> 20 (length b)) b
                             (format nil "~a~c"
                                     (subseq b 0 19)
                                     #\horizontal_ellipsis)))))
       (setf *my/str-p* out)))

    (:l ; luminosity
     (let* ((a (my/gut :lum))
            (lum (parse-integer (car a)))
            (lim (parse-integer (cdr a)))
            (out (my/out (princ-to-string (round (/ (* 100 lum) lim))))))
       (setf *my/str-l* out)))

    (:v ; volume
     ; sep 2017 (near stumpwm-88c4e90d)
     ; - https://github.com/stumpwm/stumpwm/issues/246
     ; - looks like the `bt:make-thread` must happen on this level (hence macro)
     (my/thread "my-amixer-thread"
                *my/put-amixer*
                (my/gut :vol))
     (let* ((a *my/put-amixer*)
            (vol (car a))
            (mute (cdr a))
            (out (my/out (if vol (if mute "x" vol)))))
       (setf *my/str-v* out)))

    (:k ; keyboard
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
                  (equal "on" c)))
     (let* ((hsnt *my/put-setxkbmap*)
            (caps *my/put-xset*)
            (out (my/out (funcall (if caps #'string-upcase #'identity)
                                  (if hsnt "h" "q")))))
       (setf *my/str-k* out)))

    (:b ; battery
     (let* ((a (my/chomp (my/call "acpi")))
            (b (cl-ppcre:split ", " (second (cl-ppcre:split ": " a))))
            (stat (first b))
            (perc (string-right-trim "%" (second b)))
            (alert (> 11 (parse-integer perc)))
            (icon (my/sep :icon
                          (cond
                            ((equal "Charging" stat) :bchrg)
                            (alert                   :bnone)
                            ((equal "Full" stat)     :bfull)
                            (t                       :bpart))
                          (if alert :h)))
            (out (my/out perc (if alert :h))))
       (setf *my/str-b* (concat icon out))))
    ))

;;;; command extension

;; command helpers

(defmacro my/sanitise (s)
  `(cl-ppcre:regex-replace-all "~" ,s "~~"))

(defmacro my/notify (head body)
  `(message (my/sanitise (concat ,head ": " ,body))))

;; askpass

(defcommand my/askpass (prompt) ((:string "prompt: "))
  "prompt for password"
  (read-one-line (current-screen) (concat prompt " ") :password t))

;; exec

(define-stumpwm-type :my-shell (input prompt)
  (or (argument-pop-rest input)
      (completing-read (current-screen) prompt 'complete-program)))

(defcommand my/run-prompt (cmd) ((:my-shell "Run: "))
  "orphan program starter"
  (my/run cmd))

;; hot

(defcommand my/hot-kbl () ()
  "hot command: kbl"
  (let* ((hsnt (search "+hsnt+" (my/call "setxkbmap -print")))
         (cmd (if hsnt "us" "hsnt"))
         (out (if hsnt "qwerty" "hsnt")))
    (my/call (concat "setxkbmap -option ctrl:nocaps " cmd))
    (my/acall "xset r rate 250 35")
    (my/notify "keyboard layout" out)))

(defcommand my/hot-lum (arg) ((:string "luminosity (-|+|*): "))
  "hot command: lum"
  (my/call (concat "sudo 0lum " arg))
  (let* ((a (my/gut :lum))
         (lum (parse-integer (car a)))
         (lim (parse-integer (cdr a)))
         (out (format nil "~a~d%~a"
                      (cond
                        ((equal "-" arg) "down (")
                        ((equal "+" arg) "up ("))
                      (round (/ (* lum 100) lim))
                      (if (my/in? arg '("-" "+")) ")"))))
    (my/notify "luminosity" out)))

(defcommand my/hot-play (arg) ((:string "play (p|pp|n): "))
  "hot command: play"
  (if (not (my/in? arg '("p" "pp" "n")))
      (my/notify "play" "?")
      (let* ((dbus "dbus-send --print-reply=literal --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 ")
             (memb "org.mpris.MediaPlayer2.Player")
             (stat (my/call (concat dbus "org.freedesktop.DBus.Properties.Get string:'" memb "' string:'PlaybackStatus' | sed 's/.*\\s//'")))
             (cmd (cond
                    ((equal "p" arg) "Previous")
                    ((equal "pp" arg) "PlayPause")
                    ((equal "n" arg) "Next")))
             (out (cond
                    ((equal "p" arg) "prev")
                    ((equal "n" arg) "next")
                    ((equal "Playing" stat) "pause")
                    ((equal "Paused" stat) "resume")
                    (t "?"))))
        (my/acall (concat dbus memb "." cmd))
        (my/notify "play" out))))

(defcommand my/hot-rat (arg) ((:string "touchpad (tog|dwt|*): "))
  "hot command: rat"
  (let* ((dev "PS/2 Synaptics TouchPad")
         (prop (cond
                 ((equal "dwt" arg) "libinput Disable While Typing Enabled")
                 (t "Device Enabled"))) ; arg = "tog"
         (a (my/call "xinput list"))
         (id (my/extract (concat dev "\\s+id=([0-9]+)") a))
         (b (my/call (format nil "xinput list-props ~a | grep '~a ('" id prop)))
         (old (equal "1" (first (reverse (cl-ppcre:split "\\s+" b)))))
         (cmd (cond
                ((equal "dwt" arg)
                 (format nil "set-prop ~a '~a' ~d" id prop (if old 0 1)))
                (t ; arg = "tog"
                 (concat (if old "disable" "enable") " " id))))
         (out (cond
                ((equal "dwt" arg)
                 (concat "DisableWhileTyping " (if old "off" "on")))
                (t ; arg = "tog"
                 (if old "off" "on")))))
    (my/acall (concat "xinput " cmd))
    (my/notify "touchpad" out)))

(defcommand my/hot-shot (arg) ((:string "screenshot (s|w|*): "))
  "hot command: shot"
  (let* ((dir (my/call "echo -n $HOME"))
         (file (format nil "~a/shot~a.png" dir (my/chomp (my/call "date +%s"))))
         (opt (cond
                ((equal "s" arg) "-s ")
                ((equal "w" arg) "-i $(xdotool getactivewindow) ")
                (t "")))
         (out (cond
                ((equal "s" arg) "selectshot")
                ((equal "w" arg) "windowshot")
                (t "screenshot"))))
    (funcall (if (equal "s" arg) #'my/call #'my/acall)
             (concat "maim " opt file))
    (my/notify out (format nil "taken (~a)" dir))))

(defcommand my/hot-vol (arg) ((:string "volume (x|-|--|+|++|*): "))
  "hot command: vol"
  (let* ((a (my/gut :vol))
         (vol (parse-integer (car a)))
         (mute (cdr a))
         (cal (cond
                ((equal "-"  arg) (- vol 1))
                ((equal "--" arg) (- vol 5))
                ((equal "+"  arg) (+ vol 1))
                ((equal "++" arg) (+ vol 5))
                (t vol))) ; arg = "x", *
         (new (cond
                ((my/in? arg '("-" "--")) (if (> 0   cal) 0   cal))
                ((my/in? arg '("+" "++")) (if (< 100 cal) 100 cal))
                (t cal))) ; arg = "x", *
         (val (format nil "~d%" new))
         (cmd (cond
                ((and (equal "x" arg) (not mute)) "mute")
                ((my/in? arg '("-" "--" "+" "++")) (concat val " unmute"))
                (t "unmute"))) ; arg = *
         (out (if (and (equal "x" arg) (not mute)) cmd val)))
    (my/acall (concat "amixer -q set Master " cmd))
    (my/notify "volume" out)))

;; menus

(defun my/menu (menu &optional run?)
  (labels
    ((pick (opt)
       (let ((which (select-from-menu (current-screen) opt "")))
         (cond
           ((null which) (throw 'stumpwm::error "Abort."))
           ((stringp (second which)) (second which))
           (t (pick (cdr which)))))))
    (funcall (if run? #'my/run #'run-commands) (pick menu))))

;; menu: apps

(defun my/apps-list (files)
  (mapcar
   (lambda (file)
     (let* ((term? (equal "true" (cl-xdg:get-string-key "Terminal" file)))
            (exec_ (cl-ppcre:regex-replace-all
                    " +%." (cl-xdg:get-string-key "Exec" file) ""))
            (exec (concat
                   (if term? "st -e tmux -c " "")
                   exec_))
            (name (concat
                   (cl-xdg:get-string-key "Name" file)
                   " -> "
                   (if term? "term: " "")
                   (if (> 50 (length exec_)) exec_
                       (format nil "~a~c"
                               (subseq exec_ 0 49)
                               #\horizontal_ellipsis)))))
       (list name exec)))
   files))

(defun my/apps-sort (files)
  (sort files
        (lambda (a b)
          (string-lessp (cl-xdg:get-string-key "Name" a)
                        (cl-xdg:get-string-key "Name" b)))))

(defvar my/menu-apps
  (flet ((add (h k i) (setf (gethash k h) (nconc (gethash k h) (list i)))))
    (let ((apps (make-hash-table))
          (files (loop for f being the :hash-value of
                   (slot-value (cl-xdg:load-desktop-files) 'cl-xdg::files)
                   collect f)))
      (mapcar
       (lambda (file)
         (let ((cats (cl-xdg:get-string-key "Categories" file)))
           (cond ; order matters
             ((my/in? "Network" cats)
              (add apps "net" file))
             ((my/in? "Office" cats)
              (add apps "office" file))
             ((my/in? '("Development" "Education") cats)
              (add apps "dev" file))
             ((my/in? '("Audio" "Graphics" "Video") cats)
              (add apps "media" file))
             ((my/in? '("Settings" "System") cats)
              (add apps "system" file))
             ((my/in? "Utility" cats)
              (add apps "util" file))
             ((my/in? "Wine" cats)
              (add apps "wine" file))
             (t (add apps "misc" file)))))
       files)
      (mapcar
       (lambda (c) (cons c (my/apps-list (my/apps-sort (gethash c apps)))))
       (sort (loop for c being the :hash-key of apps collect c)
             #'string-lessp)))))

(defcommand my/apps () ()
  "apps menu"
  (my/menu my/menu-apps t))

;; menu: power

(defun my/power-stop ()
  (mapcar #'my/acall
          '("alsactl --file $HOME/.config/asound.state store"
            "for i in $(ps ax | grep -- '-zsh' | grep 'Ss+' | grep pts | awk '{print $1}'); do kill -9 $i; done"
            "pkill -f connman-gtk"
            "pkill -f dunst"
            "emacsclient -e '(kill-emacs)'"
            "pkill -f uim-toolbar-gtk-systray"
            "pkill -f uim-xim"))
  (my/call "0browsertmp"))

(defcommand my/power-lock () ()
  "power menu: lock"
  (my/acall "slock"))

(defcommand my/power-quit () ()
  "power menu: lock"
  (message "quitting")
  (my/power-stop)
  (quit))

(defcommand my/power-reboot () ()
  "power menu: lock"
  (message "rebooting")
  (my/power-stop)
  (my/acall "sudo reboot"))

(defcommand my/power-halt () ()
  "power menu: lock"
  (message "halting")
  (my/power-stop)
  (my/acall "sudo halt"))

(defvar my/menu-power
  '(("lock" "my/power-lock")
    ("quit" "my/power-quit")
    ("reboot" "my/power-reboot")
    ("halt" "my/power-halt")))

(defcommand my/power () ()
  "power menu"
  (my/menu my/menu-power))

;; swank

(defcommand my/swank () ()
  "start swank"
  (swank:create-server :port 4005
                       :style swank:*communication-style*
                       :dont-close t)
  (message "Swank started. M-x slime-connect. \"(in-package :stumpwm)\"."))

;; urgent

(defun my/urgent (target)
  (format nil "^[~a~c^] ~a"
          (my/fg :r)
          #\double_exclamation_mark
          (my/sanitise (window-title target))))

(add-hook *urgent-window-hook* #'my/urgent)

;;;; the actual extending

;; modeline

(defun my/groups (active inactive)
  (flet ((show (g)
           (let* ((num (group-number g))
                  (n (cond
                       ((= 10 num) "0'")
                       ((= 9 num) "9'")
                       (t (princ-to-string num)))))
             (if (= num (group-number (current-group)))
                 (format nil "^[~a~a^]" (my/fg active) n)
                 (if (or (group-windows g)
                         (< 1 (list-length (ignore-errors (group-frames g)))))
                     n)))))
    (let* ((a (copy-list (screen-groups (current-screen))))
           (b (sort a #'< :key 'group-number))
           (c (remove-if #'null (mapcar #'show b)))
           (out (reduce (lambda (x xs) (concat x " " xs)) c)))
      (concat (my/fg inactive) out))))

(defvar my/modeline
  (list (my/char :agaric)
        "  "
        '(:eval (my/groups :kk :cc))
        "  "
        (my/sep :dot)
        (my/fg :gg)
        (my/clout "%u" :h)
        " %v^>"
        (my/sep :icon :t)
        '(:eval (my/modeline-do #'my/get :u '*my/str-u* '*my/next-u* 14))
        (my/sep :dot)
        '(:eval (my/modeline-do #'my/get :t '*my/str-t* '*my/next-t*  9))
        '(:eval (my/sep :icon :c
                 (if (or *my/alert-c* *my/alert-m* *my/alert-d*) :h)))
        '(:eval (my/modeline-do #'my/get :c '*my/str-c* '*my/next-c*  1))
        (my/sep :dot)
        '(:eval (my/modeline-do #'my/get :m '*my/str-m* '*my/next-m* 14))
        (my/sep :dot)
        '(:eval (my/modeline-do #'my/get :d '*my/str-d* '*my/next-d* 14))
        (my/sep :icon :n)
        '(:eval (my/modeline-do #'my/get :n '*my/str-n* '*my/next-n*  1))
        (my/sep :dot)
        '(:eval (my/modeline-do #'my/get :p '*my/str-p* '*my/next-p* 14))
        (my/sep :icon :l)
        '(:eval (my/modeline-do #'my/get :l '*my/str-l* '*my/next-l*  4))
        (my/sep :icon :v)
        '(:eval (my/modeline-do #'my/get :v '*my/str-v* '*my/next-v*  2))
        (my/sep :icon :k)
        '(:eval (my/modeline-do #'my/get :k '*my/str-k* '*my/next-k*  2))
        ; dynamic icon, see 'my/get :b
        '(:eval (my/modeline-do #'my/get :b '*my/str-b* '*my/next-b*  4))
        " %T"))

(setf
 *hidden-window-color* (my/fg :cc)
 *mode-line-background-color* (my/color :w)
 *mode-line-foreground-color* (my/color :cc)
 *mode-line-highlight-template* (concat "^[" (my/bg :d) (my/fg :k) " ~a ^]")
 *screen-mode-line-format* my/modeline
 *window-info-format* (format nil "%n ~a ^>~a
~a %t
~a %c
~a %i"
                              (my/clout "%m" :r)
                              (my/clout "%wx%h" :gg)
                              (my/clout "name:" :gg)
                              (my/clout "class:" :gg)
                              (my/clout "id:" :gg))
 *window-format* (format nil "^[~a%n^] %36t" (my/fg :y)))

;; hotkeys

(mapcar (lambda (x) (define-key *top-map* (kbd (car x)) (cdr x)))
        '(("XF86AudioMute"          . "my/hot-vol x")
          ("S-XF86AudioLowerVolume" . "my/hot-vol -")
          ("XF86AudioLowerVolume"   . "my/hot-vol --")
          ("S-XF86AudioRaiseVolume" . "my/hot-vol +")
          ("XF86AudioRaiseVolume"   . "my/hot-vol ++")
          ("XF86AudioPrev"          . "my/hot-play p")
          ("XF86AudioPlay"          . "my/hot-play pp")
          ("XF86AudioNext"          . "my/hot-play n")
          ("XF86Search"             . "my/hot-rat ")
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
          ("s-Return"               . "my/run-prompt")
          ("s-S-Return"             . "my/apps")
          ("s-\\"                   . "my/hot-kbl")))

(defvar *my/keymap-x*
  (let ((m (make-sparse-keymap)))
    (mapcar (lambda (x) (define-key m (kbd (car x)) (cdr x)))
            '(("h" . "exchange-direction left")
              ("j" . "exchange-direction down")
              ("k" . "exchange-direction up")
              ("l" . "exchange-direction right")
              ("r" . "repack-window-numbers")))
    m))
(define-key *top-map* (kbd "s-x") '*my/keymap-x*)
