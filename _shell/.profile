## funcs
_path_prepend()
{ case ":$PATH:" in
    *:"$1":*) ;;
    *) PATH="$1${PATH:+:$PATH}"
  esac }

## vars
_path_prepend "$HOME/.local/bin"
_path_prepend "$HOME/.cargo/bin"
_path_prepend "$HOME/bin"
unset _path_prepend
export PATH
export BROWSER=qutebrowser
export EDITOR=emacs
export TERMINAL=alacritty
export GUILE_AUTO_COMPILE=0
export MOZ_ENABLE_WAYLAND=1
#export QT_AUTO_SCREEN_SCALE_FACTOR=1
#export QT_ENABLE_HIGHDPI_SCALING=1
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export XCURSOR_SIZE=64
export XCURSOR_THEME=Breeze_Amber
export XDG_SESSION_TYPE=wayland
export XDG_MENU_PREFIX=''
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS='/usr/share:/usr/local/share'
export XDG_CACHE_HOME="$HOME/.cache"
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"
export _JAVA_AWT_WM_NONREPARENTING=1

