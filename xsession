#!/bin/sh

## vars
export PATH="$HOME/bin${PATH:+:}$PATH"
export BROWSER=icecat
#export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#export _JAVA_AWT_WM_NONREPARENTING=1
#export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.xrender=true -Dswing.aatext=true'
#export MOZ_DISABLE_PANGO=1
#export QT_QPA_PLATFORMTHEME=qt5ct

B_LOG="$HOME/.xlog"
[ -f $B_LOG ] && cp $B_LOG ${B_LOG}.old
echo '' >$B_LOG

## services
{ 0mon 2>>$B_LOG | \
  lemonbar -d -f 'Iosevka:pixelsize=13:style=bold' -g x20 -n lemonbar -p -B '#bbbbc3' -F '#5a595f' >>$B_LOG & } &
bgon 0browsertmp
bgon dunst
bgon emacs --daemon
bgon stalonetray --background '#bbbbc3' --geometry 1x1-0+0 --grow-gravity E --icon-gravity E --icon-size 20 --kludges force_icons_size --skip-taskbar --sticky

## settings
xsetroot -cursor_name left_ptr -solid '#5a595f'
xset s off dpms 900 900 900 #fp+ "$HOME/.fonts/bitmap" fp rehash
#alsactl --file "$HOME/.config/asound.state" restore
0hot bt off
0hot lum kbd 0
0hot kbd hsnt

# last for timing purposes
bgon sudo cmst

## window manager
exec dbus-launch --exit-with-session cwm
