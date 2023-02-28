#! /usr/bin/env tclsh

set d {
  .config/broot
  .config/mpv
  .emacs.d
  .icons
  .local/share/applications
  .themes/0theme/openbox-3
  bin
}
set stowd [file dirname $::argv0]
if {{relative} eq [file pathtype $::argv0]} {
  set stowd [file normalize "[pwd]/$stowd"]
}
cd $::env(HOME)
exec mkdir -p {*}$d
cd $stowd
try {
  exec >/dev/tty stow -v {*}[glob _*]
} on error e { puts $e }

