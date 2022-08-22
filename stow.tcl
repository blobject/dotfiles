#! /usr/bin/env tclsh

set stowd [file dirname $::argv0]
if {{relative} eq [file pathtype $::argv0]} {
  set stowd [file normalize "[pwd]/$stowd"]
}
cd $::env(HOME)
exec mkdir -p \
  .config/mpv \
  .emacs.d \
  .icons \
  .local/share/applications \
  bin
cd $stowd
exec stow -v {*}[glob _*]
