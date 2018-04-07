#!/bin/sh

## vars
export PATH="$HOME/bin${PATH:+:}$PATH"
export BROWSER=icecat
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
#export _JAVA_AWT_WM_NONREPARENTING=1
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.xrender=true -Dswing.aatext=true'
export MOZ_DISABLE_PANGO=1
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
export XMODIFIERS='@im=uim'
#export QT_QPA_PLATFORMTHEME=qt5ct

## settings
sudo 0lum $(expr $(cat /sys/class/backlight/intel_backlight/max_brightness) '/' 2 '-' 32 '*' 8) &
xmodmap "$HOME/cfg/hsnt.xmodmap" & # opp: setxkbmap -option ctrl:nocaps
xset  b off  m 4 4  r rate 250 35 \
  -r 121 -r 122 -r 123 -r 173 -r 172 -r 171 \
  -r 225 -r 232 -r 233 -r 107 -r 150 \
  fp+ "$HOME/.local/share/fonts/bitmap"  fp rehash &
xsetroot -cursor_name left_ptr -solid '#657b83' &

## note: let pulse restore however it wants, but restore alsa manually
#{ while [ -z "$(pidof pulseaudio)" ]; do
#  sleep 1
#  done
#  alsactl --file $HOME/.config/asound.state restore
#} &

## services
{ 0mon | lemonbar -d -f 'Iosevka:bold:pixelsize=13' -g x20 -n lemonbar -p -B '#eee8d5' -F '#93a1a1' & } &
bgin 0browsertmp
#bgin blueman-applet
bgin dunst
bgin emacs --daemon
bgin stalonetray --background '#eee8d5' --geometry 1x1-0+0 --grow-gravity E --icon-gravity E --icon-size 20 --kludges force_icons_size --skip-taskbar --sticky
bgin uim-toolbar-gtk-systray
bgin uim-xim
bgin wicd-client --no-animate --tray

## window manager
exec dbus-launch --exit-with-session cwm
