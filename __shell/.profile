. "$HOME/cfg/opt/_shell/profile_common"

# default
export BROWSER=firefox
export TERMINAL=foot

# gtk
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# qt
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
#export QT_QPA_PLATFORMTHEME=qt5ct

# graphics
if lspci | grep -q 'Radeon RX'; then
  export DRI_PRIME=1
fi
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl


# x
export XCURSOR_SIZE=64
export XCURSOR_THEME=Breeze_Snow

# xdg
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_MENU_PREFIX=''
test -z "$XDG_RUNTIME_DIR" && \
{ XDG_RUNTIME_DIR="/run/user/$(id -u)"
  export XDG_RUNTIME_DIR; }

### session-specific
if ps au | grep -q "$USER .*/usr/bin/\(openbox\|openbox-session\|startx\|xinit\)"; then
  # xorg
  export XKB_DEFAULT_LAYOUT=hsnt
else
  # wayland
  :
fi

# eof
