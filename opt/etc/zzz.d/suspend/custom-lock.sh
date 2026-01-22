#!/bin/sh

# presume wayland

locker=swaylock
locker_cmd='swaylock --daemonize --color 000000'

pidof $locker && exit

uid=1000
rundir=/run/user/$uid
display=$(ls $rundir | grep '^wayland-[0-9]\+$' | head -1)
user=$(id -un $uid)

su $user -c "env XDG_RUNTIME_DIR=$rundir WAYLAND_DISPLAY=$display $locker_cmd" &
sleep 1
