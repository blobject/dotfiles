. "$HOME/cfg/opt/_shell/profile_common"

# default
export BROWSER=firefox
export TERMINAL=foot

# gtk
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# firefox
export MOZ_DISABLE_RDD_SANDBOX=1

# qt
#export QT_AUTO_SCREEN_SCALE_FACTOR=1
#export QT_FONT_DPI=200
#export QT_QPA_PLATFORMTHEME=qt5ct

# x
export XCURSOR_SIZE=64
export XCURSOR_THEME=Breeze_Snow
export XKB_DEFAULT_LAYOUT=hsnt

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
#if ps au | grep -q "$USER .*/usr/bin/\(openbox\|openbox-session\|startx\|xinit\)"; then
#  # xorg
#else
#  # wayland
#fi

# eof
. "$HOME/.cargo/env"
