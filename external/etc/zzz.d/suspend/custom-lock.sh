#!/bin/sh

# presume wayland

locker=waylock
ps a | grep waylock | grep -qv " grep .*$locker" && exit

uid=$(ls /run/user | head -1)
home=$(getent passwd $uid | cut -d: -f6)
user=$(id -un $uid)
rundir=/run/user/$uid
display=$(ls $rundir | grep '^wayland-[0-9]\+$')
args="
-fork-on-lock
-fail-color 0xa32c2d
-init-color 0x16161d
-input-color 0x575a61
"

chpst \
  -u $user \
  env \
    USER=$user \
    HOME=$home \
    XDG_RUNTIME_DIR=$rundir \
    WAYLAND_DISPLAY=$display \
  $locker $args

