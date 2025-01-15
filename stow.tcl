#! /usr/bin/env tclsh

#.emacs.d
set home "$::env(HOME)"
set fend {
  .icons
  .local/share/applications
  .local/share/icons/hicolor/scalable/apps
  .mozilla/firefox
  bin
}
set lend [list \
  __fonts:.local/share/fonts \
    $home/opt/fonts \
  __shell:bin/0work0 \
    $home/opt/work/0work0 \
  _pycharm:.local/share/icons/hicolor/scalable/apps/pycharm.svg \
    $home/opt/pycharm/bin/pycharm.svg \
  _pycharm:bin/pycharm \
    $home/opt/pycharm/bin/pycharm.sh \
]
set stowd [file dirname $::argv0]
if {{relative} eq [file pathtype $::argv0]} {
  set stowd [file normalize "[pwd]/$stowd"]
}
cd $home
exec mkdir -p {*}$fend
cd $stowd

puts {Removing absolute links}
foreach {stowed} $lend {
  set dirrel [split $stowed :]
  set dir [lindex $dirrel 0]
  set rel [lindex $dirrel 1]
  if {[catch {exec test -L $dir/$rel} res] == 0} {
    exec rm $dir/$rel
  }
  if {[catch {exec test -L $home/$rel} res] == 0} {
    exec rm $home/$rel
  }
}

puts {Calling stow}
try {
  exec >/dev/tty stow -v {*}[glob _*]
} on error e { puts "$e" }

puts {Restoring absolute links}
foreach {stowed toload} $lend {
  set dirrel [split $stowed :]
  set dir [lindex $dirrel 0]
  set rel [lindex $dirrel 1]
  exec ln -s $toload $dir/$rel
  exec ln -s $toload $home/$rel
}
