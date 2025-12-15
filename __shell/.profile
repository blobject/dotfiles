. "$HOME/cfg/ext/shell/profile_common"

# default
export BROWSER=firefox
export TERMINAL=foot

# graphics
export LIBVA_DRIVER_NAME=iHD
export VDPAU_DRIVER=va_gl
for device in /sys/bus/pci/devices/*; do
  device_class=$(cat $device/class 2> /dev/null)
  device_vendor=$(cat $device/vendor 2> /dev/null)
  # display class and Radeon vendor
  if test $device_class = 0x030000 -a $device_vendor = 0x1002; then
    export DRI_PRIME=1
    export LIBVA_DRIVER_NAME=radeonsi
    export VDPAU_DRIVER=radeonsi
    break
  fi
done

# gtk
export GTK2_RC_FILES="$HOME/.gtkrc-2.0"

# qt
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export QT_ENABLE_HIGHDPI_SCALING=1
#export QT_QPA_PLATFORMTHEME=qt5ct

# x
export XCURSOR_SIZE=64
export XCURSOR_THEME=Breeze_Hacked
export XKB_DEFAULT_LAYOUT=hsnt

# xdg
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_DIRS=/etc/xdg
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_DATA_DIRS=/usr/local/share:/usr/share
export XDG_MENU_PREFIX=''
if test -z "$XDG_RUNTIME_DIR"; then
  export XDG_RUNTIME_DIR="/run/user/$(id -u)"
fi

# eof
