# vars
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export BROWSER=vivaldi
export MOZ_DISABLE_PANGO=1
export XIM=nabi
export XIM_ARGS=
export XIM_PROGRAM=nabi
export XMODIFIERS='@im=nabi'
export GTK_IM_MODULE=xim
export QT_IM_MODULE=xim

# settings
sudo 0lum 473
xsetroot -cursor_name left_ptr -solid '#073642'
setxkbmap hsnt
xmodmap $HOME/.xmodmap
xset  b off  m 4 4  r rate 250 35 \
  -r 121 -r 122 -r 123 -r 173 -r 172 -r 171 \
  -r 225 -r 232 -r 233 -r 107 -r 150 \
  fp+ $HOME/.fonts/bitmap  fp rehash
xrdb $HOME/.xresources

# more vars
echo '-1' >$B_IPC  # defined in .zshrc; see 0mon,0hot
eval $(keychain --eval --quick --quiet --agents ssh id_rsa)  # cb6ebccf

# services
bgin nabi
bgin wicd-gtk -t
0browsertmp &  # cf. .zlogout

# start wm
exec i3
