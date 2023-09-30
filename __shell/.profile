source "$HOME/cfg/external/_shell/profile_common"

export BROWSER=firefox
export TERMINAL=foot
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export _JAVA_AWT_WM_NONREPARENTING=1
export MOZ_DISABLE_RDD_SANDBOX=1
#export QT_QPA_PLATFORMTHEME=qt5ct
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_MENU_PREFIX=''

## xdg_runtime_dir for wlroots, seatd
test -z "$XDG_RUNTIME_DIR" && \
{ XDG_RUNTIME_DIR="/run/user/$(id -u)"
  export XDG_RUNTIME_DIR; }

## session-specific
if test '' = "$WAYLAND_DISPLAY" && test -n "$DISPLAY"; then
  # x
  export DESKTOP_SESSION=openbox
  #export QT_AUTO_SCREEN_SCALE_FACTOR=1
  #export QT_FONT_DPI=200
  export XCURSOR_THEME=Breeze_Snow
  export XCURSOR_SIZE=64
  export XDG_CURRENT_DESKTOP=cwm
else
  # wayland
  export CLUTTER_BACKEND=wayland
  export DESKTOP_SESSION=labwc
  export GDK_BACKEND=wayland
  export GDK_DPI_SCALE=1.75
  export MOZ_ENABLE_WAYLAND=1
  #export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_QPA_PLATFORM=wayland-egl
  export SDL_VIDEODRIVER=wayland
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=wlroots
  export XDG_CURRENT_DESKTOP=wlroots
  export XDG_CURRENT_SESSION=wlroots
fi
# eof
