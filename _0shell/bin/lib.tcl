#! /usr/bin/env tclsh

###############################################################################
# lib.tcl: helper variables and procedures for tcl utilities

###############################################################################

set LOGW "$::env(HOME)/wayland.log"
set LOGX "$::env(HOME)/x.log"
set ME [file tail $::argv0]
set TMPD "/tmp/_$::env(USER)"
set SESS {}
if {[info exist ::env(WAYLAND_DISPLAY)] && {} ne $::env(WAYLAND_DISPLAY)} {
  set SESS w
}
if {{w} ne $SESS && [info exist ::env(DISPLAY)] && {} ne $::env(DISPLAY)} {
  set SESS x
}

###############################################################################

proc err {s {nome {}}} {
  if {{} eq $nome} {
    global ME
    puts -nonewline stderr "$ME: "
  }
  puts stderr "$s"
}

proc fail {s {nome {}}} {
  err $s $nome
  exit 1
}

proc usage {body} {
  global ME
  fail "Usage: $ME $body" nome
}

proc need {args} {
  set want false
  foreach cmd $args {
    if [catch {exec which $cmd}] {
      set want true
      err "need $cmd";
    }
  }
  if {$want} { exit 1; }
}

