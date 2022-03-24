## funcs
_path_prepend()
{ case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="$1${PATH:+:$PATH}"
  esac }

## vars
_path_prepend $HOME/.local/bin
_path_prepend $HOME/.cargo/bin
_path_prepend $HOME/bin
# first lookup should be prepended last
unset _path_prepend
export PATH
export BROWSER=firefox-wayland
export EDITOR=kak
export TERMINAL=alacritty
export _JAVA_AWT_WM_NONREPARENTING=1
export GTK2_RC_FILES=$HOME/.gtkrc-2.0
export GUILE_AUTO_COMPILE=0
export QT_QPA_PLATFORMTHEME=qt5ct
export XCURSOR_THEME=Breeze_Snow
export XCURSOR_SIZE=64
export XDG_CACHE_HOME=$HOME/.cache
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_HOME=$HOME/.local/share
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_MENU_PREFIX=''

## session-specific
if [[ 'z' = "z$WAYLAND_DISPLAY" ]] && [[ -n $DISPLAY ]]; then
  # x
  #export QT_AUTO_SCREEN_SCALE_FACTOR=1
  #export QT_FONT_DPI=200
  export XDG_CURRENT_DESKTOP=cwm
else
  # wayland
  export CLUTTER_BACKEND=wayland
  export GDK_BACKEND=wayland
  export GDK_DPI_SCALE=2.0
  export MOZ_ENABLE_WAYLAND=1
  #export QT_AUTO_SCREEN_SCALE_FACTOR=1
  export QT_QPA_PLATFORM=wayland
  export SDL_VIDEODRIVER=wayland
  export XDG_SESSION_TYPE=wayland
  export XDG_SESSION_DESKTOP=sway
  export XDG_CURRENT_DESKTOP=sway
  export XDG_CURRENT_SESSION=sway
  #export XDG_SESSION_DESKTOP=wlroots
  #export XDG_CURRENT_DESKTOP=wlroots
  #export XDG_CURRENT_SESSION=wlroots
fi

[[ -f $HOME/.bash_profile ]] || . $HOME/.bashrc

