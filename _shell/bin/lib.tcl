#! /usr/bin/env tclsh

set ME [file tail $::argv0]
set TMPD "/tmp/_$::env(USER)"
set SESS {}
if {[info exist ::env(WAYLAND_DISPLAY)] && {} ne $::env(WAYLAND_DISPLAY)} {
  set SESS w
}
if {{w} ne $SESS && [info exist ::env(DISPLAY)] && {} ne $::env(DISPLAY)} {
  set SESS x
}

proc err {s nome} {
  if {{} eq $nome} {
    global ME
    puts -nonewline stderr "$ME: "
  }
  puts stderr "$s"
}
proc fail {s nome} {
  err $s $nome
  exit 1
}
proc need {args} {
  foreach cmd $args {
    if [catch {exec which $cmd}] { fail "need $cmd"; }
  }
}

