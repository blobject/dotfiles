{ 0snooze & } &
{ 0temper & } &
{ pipewire & } &
setxkbmap hsnt
xrdb -merge $HOME/.xresources
xset fp rehash r rate 250 30
xwallpaper --daemon --center $HOME/cfg/unstowed/back.jpg
{ sleep 1 && polybar 0bar & } &
{ sleep 2 && blueman-tray & } &
exec dbus-launch --exit-with-session cwm
