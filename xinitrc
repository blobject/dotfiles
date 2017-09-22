# vars
export BROWSER=google-chrome-beta
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=lcd -Dsun.java2d.xrender=true -Dswing.aatext=true'
#export LIBGL_DRI3_DISABLE=1 # for steam
export MOZ_DISABLE_PANGO=1
export GTK_IM_MODULE=uim
export QT_IM_MODULE=uim
export XMODIFIERS=@im=uim
export SQUEAK_IMAGE=$HOME/opt/squeak/SBE.image
export SUDO_ASKPASS=/usr/local/bin/0askpass #SSH_ASKPASS

# settings
sudo 0lum $(expr $(cat /sys/class/backlight/intel_backlight/max_brightness) '/' 2 '-' 32 '*' 6)
setxkbmap -option ctrl:nocaps hsnt # intl
xset  b off  m 4 4  r rate 250 35 \
  -r 121 -r 122 -r 123 -r 173 -r 172 -r 171 \
  -r 225 -r 232 -r 233 -r 107 -r 150 \
  fp+ $HOME/.local/share/fonts/bitmap  fp rehash
xsetroot -cursor_name left_ptr -solid '#657b83'

# note: let pulse restore however it wants, but restore alsa manually
{ while [ -z "$(pidof pulseaudio)" ]; do
  sleep 1
  done
  alsactl --file $HOME/.config/asound.state restore
} &

# services
bgin 0browsertmp
#bgin blueman-applet
bgin connman-gtk
bgin dunst
bgin emacs --daemon
bgin uim-toolbar-gtk-systray
bgin uim-xim
eval $(keychain --eval --quick --quiet --agents ssh id_rsa) # cb6ebccf

# start wm
exec stumpwm # cwm
