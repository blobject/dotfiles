#! /usr/bin/env tclsh

set ME [file tail $::argv0]
set TMPD "/tmp/_$::env(USER)"
set SESS {}
if {[info exists ::env(WAYLAND_DISPLAY)] && {} ne $::env(WAYLAND_DISPLAY)} {
  set SESS w
}
if {{w} ne $SESS && [info exists ::env(DISPLAY)] && {} ne $::env(DISPLAY)} {
  set SESS x
}

proc err {s} { global ME; puts stderr "$ME: $s" }
proc fail {s} { err $s; exit 1 }
proc need {args} {
  foreach cmd $args {
    if [catch {exec which $cmd}] { fail "need $cmd" }
  }
}

