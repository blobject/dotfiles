#! /usr/bin/env tclsh

#.emacs.d
set fend {
  .config/broot
  .icons
  .local/share/applications
  .local/share/icons/hicolor/scalable/apps
  .mozilla/firefox
  .themes/0theme/openbox-3
  bin
}
set stowd [file dirname $::argv0]
if {{relative} eq [file pathtype $::argv0]} {
  set stowd [file normalize "[pwd]/$stowd"]
}
cd $::env(HOME)
exec mkdir -p {*}$fend
cd $stowd
try {
  exec >/dev/tty stow -v {*}[glob _*]
} on error e { puts $e }

