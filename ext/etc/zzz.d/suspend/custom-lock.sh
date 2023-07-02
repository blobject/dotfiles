#!/bin/sh

# presume wayland

uid=$(ls /run/user | head -1)
user=$(id -un $uid)
home=$(getent passwd $user | cut -d: -f6)
rundir=/run/user/$uid
display=$(ls $rundir | grep '^wayland-[0-9]\+$')

chpst \
  -u $USER \
  env \
    USER=$user \
    HOME=$home \
    XDG_RUNTIME_DIR=$rundir \
    WAYLAND_DISPLAY=$display \
  $home/bin/0s bye lock

