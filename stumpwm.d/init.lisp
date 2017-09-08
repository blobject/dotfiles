;; -*-lisp-*-

(in-package :stumpwm)

(load "~/.quicklisp/dists/quicklisp/software/slime-v2.20/swank-loader.lisp")
(swank-loader:init)
(mapcar #'load-module
        '("notifications"
          "stumptray"
          "ttf-fonts"))
(load "~/.stumpwm.d/custom.lisp")

(grename "A")
(mapcar #'gnewbg '("B" "C" "D" "E" "F" "G" "H" "J" "K"))

(mapcar #'(lambda (x) (undefine-key *root-map* (kbd x)))
        '("Left" "Down" "Up" "Right" "Tab" ";" "'" "\"" "!"
          "a" "b" "c" "f" "F" "g" "G" "k" "K"
          "l" "n" "o" "p" "R" "s" "S" "v" "C-h"))
(mapcar #'(lambda (x) (define-key *root-map* (kbd (car x)) (cadr x)))
        '(("F10" "other")
          ("w"   "windows")))
(mapcar #'(lambda (x) (define-key *top-map* (kbd (car x)) (cadr x)))
        '(("M-s-Escape"  "kill")
          ("s-BackSpace" "remove-split")
          ("s-."         "next-in-frame")
          ("s-;"         "vsplit")
          ("M-s-;"       "hsplit")
          ("s-="         "balance-frames")
          ("s-`"         "float-this")
          ("s-!"         "exec")
          ("s-@"         "eval")
          ("s-#"         "colon")
          ("s-f"         "fullscreen")
          ("s-r"         "iresize")
          ("M-s-r"       "loadrc")
          ("s-Right"     "gnext")
          ("s-Left"      "gprev")
          ("s-1"   "gselect A")
          ("s-2"   "gselect B")
          ("s-3"   "gselect C")
          ("s-4"   "gselect D")
          ("s-5"   "gselect E")
          ("s-6"   "gselect F")
          ("s-7"   "gselect G")
          ("s-8"   "gselect H")
          ("s-9"   "gselect J")
          ("s-0"   "gselect K")
          ("M-s-1" "gmove A")
          ("M-s-2" "gmove B")
          ("M-s-3" "gmove C")
          ("M-s-4" "gmove D")
          ("M-s-5" "gmove E")
          ("M-s-6" "gmove F")
          ("M-s-7" "gmove G")
          ("M-s-8" "gmove H")
          ("M-s-9" "gmove J")
          ("M-s-0" "gmove K")
          ("s-h"   "move-focus left")
          ("s-j"   "move-focus down")
          ("s-k"   "move-focus up")
          ("s-l"   "move-focus right")
          ("M-s-h" "move-window left")
          ("M-s-j" "move-window down")
          ("M-s-k" "move-window up")
          ("M-s-l" "move-window right")
          ("XF86AudioMute"          "exec 0hot vol x")
          ("S-XF86AudioLowerVolume" "exec 0hot vol -")
          ("XF86AudioLowerVolume"   "exec 0hot vol --")
          ("S-XF86AudioRaiseVolume" "exec 0hot vol +")
          ("XF86AudioRaiseVolume"   "exec 0hot vol ++")
          ("XF86Search"             "exec 0hot rat dwt")
          ("XF86MonBrightnessDown"  "exec 0hot lum -")
          ("XF86MonBrightnessUp"    "exec 0hot lum +")
          ("XF86AudioRewind"        "exec 0hot lum -")
          ("XF86AudioForward"       "exec 0hot lum +")
          ("Print"                  "exec 0hot shot")
          ("S-Print"                "exec 0hot shot s")
          ("C-Print"                "exec 0hot shot w")
          ("XF86PowerOff"           "exec 0pow Lock")
          ("C-M-BackSpace"          "exec 0pow")
          ("C-M-Delete"             "exec 0pow")
          ("s-Return" "exec rofi -m '-1' -show run")
          ("s-\\"  "exec 0hot kbl")
          ("s-e"   "exec emacsclient -nc")
          ("s-m"   "exec thunderbird-bin")
          ("s-t"   "exec st -e tmux")
          ("M-s-t" "exec st-alt")
          ("s-w"   "exec google-chrome-stable --disk-cache-dir=/tmp/b_tmp_chrome_cache")
          ("M-s-w" "exec firefox-bin")
          ))

(defun my/color (key)
  (let ((cs '(:k  "#073642" :kk "#002b36"
              :r  "#dc322f" :rr "#cb4b16"
              :g  "#859900" :gg "#586e75"
              :y  "#b58900" :yy "#657b83"
              :b  "#268bd2" :bb "#839496"
              :m  "#d33682" :mm "#6c71c4"
              :c  "#2aa198" :cc "#93a1a1"
              :w  "#eee8d5" :ww "#fdf6e3")))
    (getf cs key)))

(set-font (make-instance 'xft:font :family "Iosevka" :subfamily "Bold" :size 10))
(set-fg-color            (my/color :k))
(set-bg-color            (my/color :cc))
(set-border-color        (my/color :mm))
(set-msg-border-width    3)
(set-focus-color         (my/color :cc))
(set-unfocus-color       (my/color :w))
(set-win-bg-color        (my/color :ww))
(set-float-focus-color   (my/color :cc))
(set-float-unfocus-color (my/color :w))
(set-prefix-key          (kbd "F10"))

(setf
 *startup-message* nil
 *suppress-frame-indicator* t
 *mouse-focus-policy* :ignore
 *message-window-gravity* :bottom
 *input-window-gravity* :bottom
 *input-history-ignore-duplicates* t

 *message-window-padding* 5
 *normal-border-width* 4
 *maxsize-border-width* 4
 *transient-border-width* 4
 *window-border-style* :thin
 *min-frame-width* 100
 *min-frame-height* 100
 *resize-increment* 20

 *mode-line-background-color* (my/color :w)
 *mode-line-foreground-color* (my/color :kk)
 *mode-line-border-color* (my/color :w)
 *mode-line-border-width* 0
 *mode-line-timeout* 1

 stumptray:*tray-viwin-background* (my/color :w)
 stumptray:*tray-hiwin-background* (my/color :w)
 stumptray:*tray-placeholder-pixels-per-space* 7
 )

(setf
 *group-format* "%t"
 ;*window-format*   "^B^87%s^9*%m^0*%16t^n"
 *window-format* (format nil "^b^(:fg \"~a\")%40t" (my/color :k))
 *screen-mode-line-format* my/modeline
 )

(if (not (head-mode-line (current-head)))
    (toggle-mode-line (current-screen) (current-head)))
(stumptray:stumptray)
