#!/bin/sh

# presume wayland

locker=hyprlock
locker_cmd='hyprlock --immediate --immediate-render --no-fade-in'

pidof $locker && exit

uid=1000
rundir=/run/user/$uid

doas -u $user \
  env \
    USER=$(id -un $uid) \
    HOME=$(getent passwd $uid | cut -d: -f6) \
    XDG_RUNTIME_DIR= \
    WAYLAND_DISPLAY=$(ls $rundir | grep '^wayland-[0-9]\+$' | head -1) \
  $locker_cmd &
