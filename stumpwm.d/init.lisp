;; -*-lisp-*-

(declaim (optimize (speed 3) (space 0) (debug 3) (safety 3)))

;(ql:quickload "alexandria")
;(ql:quickload "cl-ppcre")
;(ql:quickload "clx")
;(ql:quickload "clx-truetype")
;(xft:cache-fonts)

(mapcar #'load-module
        '("stumptray"
          "ttf-fonts"))

(in-package :stumpwm)

(defun my/color (key)
  (let ((cs '(:k "#073642" :kk "#002b36"
              :r "#dc322f" :rr "#cb4b16"
              :g "#859900" :gg "#586e75"
              :y "#b58900" :yy "#657b83"
              :b "#268bd2" :bb "#839496"
              :m "#d33682" :mm "#6c71c4"
              :c "#2aa198" :cc "#93a1a1"
              :w "#eee8d5" :ww "#fdf6e3"
              :dim "#d9d3c2")))
    (getf cs key)))

(grename "A")
(mapcar #'gnewbg '("B" "C" "D" "E" "F" "G" "H"))
(gnewbg-float "float")

(mapcar (lambda (x) (undefine-key *root-map* (kbd x)))
        '("Left" "Down" "Up" "Right" "Tab"
          ";" "'" "\"" "!"
          "a" "b" "c" "f" "F" "g" "G" "k" "K"
          "l" "n" "o" "p" "R" "s" "S" "v"
          "C-c" "C-h"))

(mapcar (lambda (x) (define-key *root-map* (kbd (car x)) (cdr x)))
        '(("F10" . "other")
          ("w"   . "windows")))

(mapcar (lambda (x) (define-key *top-map* (kbd (car x)) (cdr x)))
        '(("M-s-Escape" . "kill")
          ("s-Return"   . "vsplit")
          ("M-s-Return" . "hsplit")
          ("S-s-Return" . "remove-split")
          ("s-space"    . "info")
          ("s-Left"     . "gprev")
          ("s-Right"    . "gnext")
          ("s-`"        . "float-this")
          ("s-="        . "balance-frames")
          ("s-;"        . "eval")
          ("s-:"        . "colon")
          ("s-'"        . "pull-hidden-next")
          ("s-\""       . "pull-hidden-previous")
          ("s-,"        . "prev-in-frame")
          ("s-."        . "next-in-frame")
          ("s-/"        . "windowlist")
          ("s-f"        . "fullscreen")
          ("s-g"        . "abort")
          ("s-r"        . "iresize")
          ("M-s-r"      . "loadrc")
          ("s-u"        . "next-urgent")
          ("s-1"   . "gselect A")
          ("s-2"   . "gselect B")
          ("s-3"   . "gselect C")
          ("s-4"   . "gselect D")
          ("s-5"   . "gselect E")
          ("s-6"   . "gselect F")
          ("s-7"   . "gselect G")
          ("s-8"   . "gselect H")
          ("s-9"   . "gselect float")
          ("M-s-1" . "gmove A")
          ("M-s-2" . "gmove B")
          ("M-s-3" . "gmove C")
          ("M-s-4" . "gmove D")
          ("M-s-5" . "gmove E")
          ("M-s-6" . "gmove F")
          ("M-s-7" . "gmove G")
          ("M-s-8" . "gmove H")
          ("M-s-9" . "gmove float")
          ("s-h"   . "move-focus left")
          ("s-j"   . "move-focus down")
          ("s-k"   . "move-focus up")
          ("s-l"   . "move-focus right")
          ("M-s-h" . "move-window left")
          ("M-s-j" . "move-window down")
          ("M-s-k" . "move-window up")
          ("M-s-l" . "move-window right")
          ("s-e"   . "exec bgin emacsclient -nc")
          ("M-s-f" . "exec bgin 0cwm")
          ("s-m"   . "exec bgin thunderbird-bin")
          ("s-t"   . "exec bgin st -e tmux")
          ("M-s-t" . "exec bgin st-alt")
          ("s-w"   . "exec bgin google-chrome-stable --disk-cache-dir=/tmp/b_tmp_chrome_cache")
          ("M-s-w" . "exec bgin firefox-bin")))

(set-font (make-instance 'xft:font :family "Iosevka" :subfamily "Bold" :size 10))
(set-prefix-key          (kbd "F10"))
(set-fg-color            (my/color :k))
(set-bg-color            (my/color :cc))
(set-border-color        (my/color :mm))
(set-msg-border-width    3)
(set-focus-color         (my/color :cc))
(set-unfocus-color       (my/color :w))
(set-win-bg-color        (my/color :ww))
(set-float-focus-color   (my/color :cc))
(set-float-unfocus-color (my/color :w))
(set-normal-gravity      :center)
(set-maxsize-gravity     :center)
(set-transient-gravity   :center)

(setf
 *startup-message*                 nil
 *suppress-frame-indicator*        t
 *mouse-focus-policy*              :ignore
 *message-window-gravity*          :bottom
 *input-window-gravity*            :bottom
 *input-history-ignore-duplicates* t

 *message-window-padding* 5
 *normal-border-width*    4
 *maxsize-border-width*   4
 *transient-border-width* 4
 *window-border-style*    :thin
 *min-frame-width*        100
 *min-frame-height*       100
 *resize-increment*       50

 *mode-line-border-width* 0
 *mode-line-timeout*      600

 stumptray:*tray-viwin-background* (my/color :w)
 stumptray:*tray-hiwin-background* (my/color :w)
 stumptray:*tray-placeholder-pixels-per-space* 7)

(load "~/.stumpwm.d/ext.lisp")
(if (not (head-mode-line (current-head)))
    (toggle-mode-line (current-screen) (current-head)))
(stumptray:stumptray)
