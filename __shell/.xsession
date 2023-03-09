# early & one-off
gsettings set org.gnome.desktop.interface cursor-theme Breeze_Snow
gsettings set org.gnome.desktop.interface cursor-size 64
gsettings set org.gnome.desktop.interface font-name 'sans 20'
gsettings set org.gnome.desktop.interface gtk-theme Adwaita
gsettings set org.gnome.desktop.interface icon-theme Papirus
hsetroot -solid '#000' &
setxkbmap hsnt &
xrdb -merge $HOME/.xresources &
xset fp rehash r rate 250 30 &

# daemon
{ 0s snooze & } &
{ 0s temper & } &
{ iwgtk -i & } &
{ pipewire & } &
{ sleep 1 && polybar 0bar & } &
{ sleep 3 && blueman-applet & } &
{ sleep 3 && wireplumber & } &
exec dbus-launch --exit-with-session cwm
