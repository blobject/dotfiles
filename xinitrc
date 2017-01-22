# vars
export BROWSER=google-chrome-stable
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=gasp'
export MOZ_DISABLE_PANGO=1
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
export XMODIFIERS=@im=uim

# settings
sudo 0lum $(expr $(cat /sys/class/backlight/intel_backlight/max_brightness) / 2)
sudo 0shed
setxkbmap -option ctrl:nocaps hsnt
xset  b off  m 4 4  r rate 250 35 \
  -r 121 -r 122 -r 123 -r 173 -r 172 -r 171 \
  -r 225 -r 232 -r 233 -r 107 -r 150 \
  fp+ $HOME/.fonts/bitmap  fp rehash
xsetroot -cursor_name left_ptr -solid '#073642'
xrdb $HOME/.xresources

# services
bgin 0browsertmp  # cf. 0pow
bgin dunst
bgin emacs --daemon
bgin uim-toolbar-gtk-systray
bgin uim-xim
bgin wicd-gtk -t
eval $(keychain --eval --quick --quiet --agents ssh id_rsa)  # cb6ebccf

# start wm
exec ck-launch-session dbus-launch --sh-syntax --exit-with-session i3
