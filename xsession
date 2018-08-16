#!/bin/sh

## vars
export PATH="$HOME/bin${PATH:+:}$PATH"
export BROWSER=icecat
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#export _JAVA_AWT_WM_NONREPARENTING=1
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.xrender=true -Dswing.aatext=true'
#export MOZ_DISABLE_PANGO=1
export QT_QPA_PLATFORMTHEME=qt5ct

_LOG="$HOME/.xlog"
[ -f $_LOG ] && cp $_LOG ${_LOG}.old
echo '' >$_LOG

## services
{ 0mon 2>>$_LOG | \
  lemonbar -d -f 'Iosevka:pixelsize=13:style=bold' -g x20 -n lemonbar -p -B '#eee8d5' -F '#93a1a1' >>$_LOG & } &
bgon stalonetray --background '#eee8d5' --geometry 1x1-0+0 --grow-gravity E --icon-gravity E --icon-size 20 --kludges force_icons_size --skip-taskbar --sticky
bgon 0browsertmp
#bgon blueman-applet
bgon sudo cmst
bgon dunst
bgon emacs --daemon

## settings
#sudo 0lum m 150 >/dev/null &
sudo 0lum k 0 >/dev/null &
0hot kbd hsnt-quiet &
#alsactl --file "$HOME/.config/asound.state" restore &
#xset fp+ "$HOME/.local/share/fonts/bitmap" fp rehash &
xsetroot -cursor_name left_ptr -solid '#657b83' &

## window manager
exec dbus-launch --exit-with-session cwm
