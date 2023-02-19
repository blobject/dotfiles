{ 0s snooze & } &
{ 0s temper & } &
{ pipewire & } &
setxkbmap hsnt
xrdb -merge $HOME/.xresources
xset fp rehash r rate 250 30
{ sleep 1 && polybar 0bar & } &
{ sleep 2 && blueman-applet & } &
exec dbus-launch --exit-with-session cwm
