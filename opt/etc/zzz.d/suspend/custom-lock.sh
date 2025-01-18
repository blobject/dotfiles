#!/bin/sh

# presume wayland

locker=hyprlock

pidof $locker && exit

uid=1000
home=$(getent passwd $uid | cut -d: -f6)
user=$(id -un $uid)
rundir=/run/user/$uid
display=$(ls $rundir | grep '^wayland-[0-9]\+$')

chpst \
  -u $user \
  env \
    USER=$user \
    HOME=$home \
    XDG_RUNTIME_DIR=$rundir \
    WAYLAND_DISPLAY=$display \
  $locker

