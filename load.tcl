#! /usr/bin/env tclsh

###############################################################################
# load.tcl: setup environment after a fresh VoidLinux install

set USER b
set HOME /home/$USER
set STOW $HOME/cfg/stow.tcl
set UPDATE {xbps-install -Su}
set INSTALL {xbps-install -S}
set REMOVE {xbps-remove -R}
set CLEANUP {xbps-remove -Oo}
set GITHUB git@github.com:blobject
set GITHUBPUB https://github.com
set SUDO /usr/bin/sudo

###############################################################################
# helpers

proc read_file {f} {
  set h [open $f r]
  set c [read -nonewline $h]
  close $h
  return $c
}

proc title {t} {
  set c :
  set len [string length $t]
  set limit 60
  set one [expr [expr $limit - $len - 2] / 2]
  set two [expr $limit - $one - 2 - $len]
  return "\n[string repeat $c $one] $t [string repeat $c $two]\n"
}

###############################################################################

proc intro {done_preq done_user} {
  global UPDATE

  set preq_tag {}
  set preq_ex { ------ curl, git, iwd, logging}
  if {$done_preq} { set preq_tag {(done) }; set preq_ex {} }
  set user_tag {}
  set user_ex { ----------------- groups, git, ssh, ...}
  if {$done_user} { set user_tag {(done) }; set user_ex {} }

  set hostname [exec uname -n]
  set kernel [exec uname -r]
  set os [read_file /etc/os-release]
  regsub {^.*ID="([^\"]*)".*$} $os {\1} os
  set disk [exec df | grep {/$} | cut -f1 {-d }]

  puts "ready to setup \"${hostname}\"
(${os} ${kernel}, root=${disk})
[title STEPS]
 0. ${preq_tag}install PREREQUISITES${preq_ex}
 1. ${user_tag}setup USER${user_ex}
 2. update PACKAGE SYSTEM ------ ${UPDATE}
 3. setup BOOT ----------------- fstab, refind
 4. remove NEEDLESS ------------ grub, wpa_supplicant
 5. setup BASIC SYSTEM --------- rc, timezone, tlp, ...
 6. install/setup BASICS ------- firmware, stow, zip, ...
 7. install/setup DESKTOP ------ xorg, xterm, wayland, ...
 8. install/setup MISCELLANY --- vim, libs, pipewire, ...
 9. stow
10. install/setup BULKIES ------ libreoffice, texlive, ...
11. populate OPT --------------- plugins, standalones, ...
12. update KERNEL --- oldconfig, modules, cp, dracut, sed
done

make sure:
- not chroot'd
- connected to internet
- stowable config at HOME/cfg
"
  flush stdout

  set input {}
  while {$input ni {Y N n Q q}} {
    puts -nonewline {begin? [Y/n] }
    flush stdout
    set input [gets stdin]
    if {{y} eq $input} {
      puts -nonewline {capital Y please; }
    }
  }
  if {$input in {N n Q q}} {
    puts quit
    exit 0
  }
}

proc outro {} {
  puts "[title DONE]
left to do:
- install fonts
- configure firefox, restore bookmarks
- configure libreoffice
- login and configure all web apps
- check everything
- repopulate personal files (dev, ref, sec, ...)
"
  flush stdout
}

###############################################################################

proc prerequisites {isdone} {
  puts [title {0: install PREREQUISITES}]
  if {$isdone} {
    puts {already done; skipping}
    flush stdout
    return
  }
  puts done
}

proc user {name isdone} {
  puts [title {1. setup USER}]
  if {$isdone} {
    puts {already done; skipping}
    flush stdout
    return
  }
  puts done
}

###############################################################################

proc package {} {
  global UPDATE SUDO

  puts [title {2. update PACKAGE SYSTEM}]
  exec $SUDO {*}$UPDATE
  puts done
}

proc boot {} {
}

proc needless {} {
}

###############################################################################

proc system {} {
  global HOME GITHUB

  exec mkdir bak got log mnt opt ref src
  exec git clone $GITHUB/dotfiles.git cfg
}

###############################################################################

proc basics {} {
}

proc desktop {} {
  global SUDO

  #exec $SUDO mkdir -p /usr/share/xsessions
}

proc miscellany {} {
}

###############################################################################

proc stow {} {
  global HOME

  cd $HOME
}

proc bulkies {} {
}

proc opt {} {
  global HOME GITHUBPUB

  cd $HOME/opt
  exec mkdir -p kak
  cd kak
  #exec git clone $GITHUBPUB/Bodhizafa/kak-rainbow
  cd ..
}

###############################################################################

proc kernel {} {
}

###############################################################################

proc check_prerequisites {} {
  # TODO: tie it into intro and self logic (why and which failed)
  if {{link} ne [file type /var/service/socklog-unix]} { return false }
  if {![file executable /usr/bin/curl]} { return false }
  if {![file executable /usr/bin/git]} { return false }
  if {{link} ne [file type /var/service/iwd]} { return false }
  if {![file executable /usr/bin/iwctl]} { return false }
  if {{link} ne [file type /var/service/socklog-unix]} { return false }
  return true
}

proc check_user {name} {
  global HOME

  # TODO: tie it into intro and self logic (why and which failed)
  if {![file isdirectory $HOME]} { return false }
  if {![file exists .ssh/id_rsa]} { return false }
  if {0 == [glob -nocomplain -directory .gnupg/private-keys-v1.d *.key]} {
    return false
  }
  if {![file exists .gitconfig]} { return false }
  return true
}

set done_preq [check_prerequisites]
set done_user [check_user $USER]
intro $done_preq $done_user
prerequisites $done_preq
user $USER $done_user
package
boot
needless
system
basics
desktop
miscellany
stow
bulkies
kernel
opt
outro

