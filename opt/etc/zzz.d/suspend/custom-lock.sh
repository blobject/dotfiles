#!/bin/sh

# presume wayland

locker=hyprlock
locker_cmd='hyprlock --immediate --immediate-render --no-fade-in'

pidof $locker && exit

uid=1000
rundir=/run/user/$uid
display=$(ls $rundir | grep '^wayland-[0-9]\+$' | head -1)
user=$(id -un $uid)

su $user -c "env XDG_RUNTIME_DIR=$rundir WAYLAND_DISPLAY=$display $locker_cmd" &
sleep 1
