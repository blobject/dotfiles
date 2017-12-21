;; -*-lisp-*-

(declaim (optimize (speed 3) (space 0) (debug 1) (safety 1)))

(load "~/.quicklisp/dists/quicklisp/software/slime-v2.20/swank-loader.lisp")
(swank-loader:init)

(ql:quickload "alexandria")
(ql:quickload "cl-ppcre")
(ql:quickload "cl-xdg")
(ql:quickload "clx")
(ql:quickload "clx-truetype")
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
              :d "#d9d3c2" :h  "#2aa198")))
    (getf cs key)))

(grename "a")
(mapcar #'gnewbg '("b" "c" "d" "e" "f" "g" "h"))
(gnewbg-float "i")
(gnewbg-float "j")

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
        '(("M-s-Escape"    . "kill")
          ("S-s-Escape"    . "delete")
          ("s-BackSpace"   . "vsplit")
          ("M-s-BackSpace" . "hsplit")
          ("s-Delete"      . "remove-split")
          ("s-space"       . "info")
          ("s-Left"        . "gprev")
          ("s-Right"       . "gnext")
          ("s-`"           . "unfloat-this")
          ("s-~"           . "float-this")
          ("s-="           . "balance-frames")
          ("s-;"           . "eval")
          ("s-:"           . "colon")
          ("s-'"           . "pull-hidden-next")
          ("s-\""          . "pull-hidden-previous")
          ("s-,"           . "prev-in-frame")
          ("s-."           . "next-in-frame")
          ("s-/"           . "windowlist")
          ("s-f"           . "fullscreen")
          ("s-g"           . "abort")
          ("s-r"           . "iresize")
          ("M-s-r"         . "loadrc")
          ("s-u"           . "next-urgent")
          ("s-1"   . "gselect a")
          ("s-2"   . "gselect b")
          ("s-3"   . "gselect c")
          ("s-4"   . "gselect d")
          ("s-5"   . "gselect e")
          ("s-6"   . "gselect f")
          ("s-7"   . "gselect g")
          ("s-8"   . "gselect h")
          ("s-9"   . "gselect i")
          ("s-0"   . "gselect j")
          ("M-s-1" . "gmove a")
          ("M-s-2" . "gmove b")
          ("M-s-3" . "gmove c")
          ("M-s-4" . "gmove d")
          ("M-s-5" . "gmove e")
          ("M-s-6" . "gmove f")
          ("M-s-7" . "gmove g")
          ("M-s-8" . "gmove h")
          ("M-s-9" . "gmove i")
          ("M-s-0" . "gmove j")
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
          ("s-t"   . "exec bgin st tmux")
          ("M-s-t" . "exec bgin st-alt")
          ("s-w"   . "exec bgin google-chrome-beta")
          ("M-s-w" . "exec bgin firefox-bin")))

(set-font
 (list
  (make-instance 'xft:font :family "Iosevka" :subfamily "Bold" :size 10)
  (make-instance 'xft:font :family "FontAwesome" :subfamily "Regular" :size 9)))
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
