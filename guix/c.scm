(define-module (my packages)
  #:use-module (gnu packages pkg-config)
  ; my-linux
  #:use-module (gnu packages compression)
  #:use-module (gnu packages linux)
  ; my-libgestures
  #:use-module (gnu packages glib)
  #:use-module (gnu packages serialization)
  ; my-cmt
  #:use-module (gnu packages xorg)

  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public my-firmware
  (package
   (name "my-firmware")
   (version "7b5835fd37630d18ac0c755329172f6a17c1af29")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
           (commit version)))
     (sha256 (base32 "111pk6867an94gqshbyrbghsn9pbzjhgswdcjwd4z7cl7ikh6q0p"))))
   (build-system trivial-build-system)
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
        (use-modules (guix build utils))
        (let* ((source (assoc-ref %build-inputs "source"))
               (fw-dir (string-append %output "/lib/firmware/"))
               (i915-dir (string-append fw-dir "i915/"))
               (intel-dir (string-append fw-dir "intel/")))
          (mkdir-p fw-dir)
          (mkdir-p i915-dir)
          (mkdir-p intel-dir)
          (for-each (lambda (file)
                      (copy-file file (string-append fw-dir (basename file))))
                    (find-files source "iwlwifi-7.*\\.ucode$"))
          (for-each (lambda (file)
                      (copy-file file (string-append i915-dir (basename file))))
                    (find-files source "skl.*\\.bin$"))
          (for-each (lambda (file)
                      (copy-file file (string-append intel-dir (basename file))))
                    (find-files source (string-append
                                        "dsp_fw_rel.*"
                                        "|ibt-hw-37\\.8\\..*")))
          (for-each (lambda (file)
                      (copy-file file (string-append fw-dir (basename file))))
                    (find-files source (string-append
                                        "LICENSE\\.i915$"
                                        "|LICENCE\\.iwlwifi_.*"
                                        "|LICENCE\\.ibt_.*")))
          #t))))
   (home-page "https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi")
   (synopsis "blobby firmware")
   (description "blobby firmware")
   (license (license:non-copyleft "https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/LICENSE.iwlwifi_firmware?id=HEAD"))))

;(define-public my-regdb
;  (package
;   (name "my-regdb")
;   (version "2018.05.31")
;   (source
;    (origin
;     (method url-fetch)
;     (uri (list "https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2018.05.31.tar.xz"))
;     (sha256 (base32 "0yxydxkmcb6iryrbazdk8lqqibig102kq323gw3p64vpjwxvrpz1"))))
;   (build-system gnu-build-system)
;   (arguments
;    `(#:phases
;      ))
;   (home-page "https://wireless.wiki.kernel.org/en/developers/regulatory/wireless-regdb")
;   (synopsis "linux wireless regulatory database")
;   (description "linux wireless regulatory database")
;   (license license:isc)))

(define-public my-skylake
  (package
   (name "my-skylake")
   (version "1b607efdf126e80b60a6bf53d25c1b3153131225")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "https://github.com/GalliumOS/galliumos-skylake.git")
           (commit version)))
     (sha256 (base32 "1hi66ilkyy92p64ix3q3wp1ljk6kzq88z4b2f39vf5y1mnxlb7w5"))))
   (build-system trivial-build-system)
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
        (use-modules (guix build utils))
        (let* ((source (assoc-ref %build-inputs "source"))
               (fw-dir (string-append %output "/lib/firmware/")))
          (mkdir-p fw-dir)
          (for-each (lambda (file)
                      (copy-file file (string-append fw-dir (basename file))))
                    (find-files source "dfw_sst\\.bin$"))
          #t))))
   (home-page "https://www.codentium.com/gentoo-on-skylake-based-chromebooks.html")
   (synopsis "support for linux on skylake-based chromebooks")
   (description "support for linux on skylake-based chromebooks")
   (license (license:non-copyleft ""))))

(define my-linux-config
  (string-append (dirname (current-filename)) "/c.kconfig"))

(define-public my-linux
  (package
   (inherit linux-libre)
   (name "my-linux")
   (version "4.18.14")
   (source
    (origin
     (method url-fetch)
     (uri (list "https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.18.14.tar.xz"))
     (sha256 (base32 "1lv2hpxzlk1yzr5dcjb0q0ylvlwx4ln2jvfvf01b9smr1lvd3iin"))))
   (native-inputs
    `(("kconfig" ,my-linux-config)
      ,@(alist-delete "kconfig" (package-native-inputs linux-libre))))
   (inputs
    `(("lz4" ,lz4)
      ,@(package-inputs linux-libre)))))

(define-public my-libevdevc
  (package
   (name "my-libevdevc")
   (version "05f67cb94888f3d9f97b5557caf4081543e8ba0e")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
            (url "https://github.com/hugegreenbug/libevdevc.git")
            (commit version)))
     (sha256 (base32 "0jnjyzh5ncdal6f125q4i5k6s7pd6ca3yha92d5prqfganlr3apd"))))
   (build-system gnu-build-system)
   (arguments
    `(#:tests? #f
      #:phases (modify-phases %standard-phases
                 (replace 'configure
                   (lambda* (#:key outputs #:allow-other-keys)
                     (substitute* "common.mk"
                       (("/bin/echo") (which "echo")))
                     (substitute* "include/module.mk"
                       (("\\$\\(DESTDIR\\)/usr/")
                        (string-append (assoc-ref outputs "out") "/")))
                     (substitute* "src/module.mk"
                       (("\\$\\(DESTDIR\\)")
                        (string-append (assoc-ref outputs "out") "/"))))))))
   (home-page "https://github.com/hugegreenbug/libevdevc")
   (synopsis "chromiumos libevdev for linux")
   (description "chromiumos libevdev for linux")
   (license license:bsd-3)))

(define-public my-libgestures
  (package
   (name "my-libgestures")
   (version "7a91f7cba9f0c5b6abde2f2b887bb7c6b70a6245")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
            (url "https://github.com/hugegreenbug/libgestures.git")
            (commit version)))
     (sha256 (base32 "03wg0jqh9ilsr9vvqmakg4dxf3x295ap2sbq7gax128vgylb79i7"))))
   (build-system gnu-build-system)
   (native-inputs
    `(("glib" ,glib)
      ("pkg-config" ,pkg-config)))
   (inputs
    `(("jsoncpp" ,jsoncpp)))
   (arguments
    `(#:tests? #f
      #:phases (modify-phases %standard-phases
                 (replace 'configure
                   (lambda* (#:key outputs #:allow-other-keys)
                            (substitute* "Makefile"
                                         (("DESTDIR = ")
                                          (string-append "DESTDIR = " (assoc-ref outputs "out"))))
                            (substitute* "include/gestures/include/finger_metrics.h"
                                         (("vector.h\"") "vector.h\"\n#include <math.h>")))))))
   (home-page "https://github.com/hugegreenbug/libgestures")
   (synopsis "chromiumos libgestures for linux")
   (description "chromiumos libgestures for linux")
   (license license:bsd-3)))

(define-public my-cmt
  (package
   (name "my-cmt")
   (version "711bbcd2dfd67ccdf635ff41d177f1ed1f755bd4")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
            (url "https://github.com/hugegreenbug/xf86-input-cmt.git")
            (commit version)))
     (sha256 (base32 "162y8v87b9xvv1zk6vj0flx8kpg91n0k9rckjf279imvyy7hz6nw"))))
   (build-system gnu-build-system)
   (native-inputs
    `(("pkg-config" ,pkg-config)))
   (inputs
    `(("libevdevc" ,my-libevdevc)
      ("libgestures" ,my-libgestures)
      ("xorg-server" ,xorg-server)
      ("xorgproto" ,xorgproto)))
   (arguments
    `(#:configure-flags
      (list (string-append "--with-sdkdir="
                           %output
                           "/include/xorg"))
      #:phases (modify-phases %standard-phases
      (add-after 'unpack 'fix-deps
        (lambda* (#:key inputs #:allow-other-keys)
          (let ((evd (assoc-ref inputs "libevdevc"))
                (ges (assoc-ref inputs "libgestures")))
            (setenv "C_INCLUDE_PATH"
                    (string-append
                      (getenv "C_INCLUDE_PATH") ":" evd "/include:" ges "/usr/include"))
            (setenv "LIBRARY_PATH"
                    (string-append
                      (getenv "LIBRARY_PATH") ":" evd "/usr/lib:" ges "/usr/lib"))
            #t))))))
   (home-page "https://github.com/hugegreenbug/xf86-input-cmt")
   (synopsis "chromiumos touchpad driver for linux")
   (description "chromiumos touchpad driver for linux")
   (license license:bsd-3)))

(use-modules (gnu) (srfi srfi-1) (my packages))
(use-system-modules nss)
(use-service-modules admin cups dbus desktop mcron networking sysctl xorg)
(use-package-modules certs connman cups libusb suckless video wm)

(define %%user "b")
(define %%host "c")
(define %%home (string-append "/home/" %%user))

(define my-xorg-modules
  (cons my-cmt
        (fold delete %default-xorg-modules
              '("xf86-input-evdev"
                "xf86-input-keyboard"
                "xf86-input-mouse"
                "xf86-input-synaptics"
                "xf86-video-ati"
                "xf86-video-cirrus"
                "xf86-video-fbdev"
                "xf86-video-mach64"
                "xf86-video-nouveau"
                "xf86-video-nv"
                "xf86-video-sis"
                "xf86-video-vesa"))))

(define my-xorg-config "
Section \"Device\"
  Identifier \"intel\"
  Driver \"intel\"
  Option \"DRI\" \"3\"
  #Option \"AccelMethod\" \"sna\"
  #Option \"TearFree\" \"true\"
EndSection
Section \"InputClass\"
  Identifier \"keyboard\"
  MatchProduct \"AT Translated Set 2 keyboard\"
  MatchIsKeyboard \"1\"
  #Option \"XkbModel\" \"chromebook\"
EndSection
Section \"InputClass\"
  Identifier \"touchpad\"
  MatchProduct \"Elan Touchpad\"
  MatchIsTouchpad \"1\"
  Driver \"cmt\"
  Option \"XkbModel\" \"pc\"
  Option \"XkbLayout\" \"us\"
  Option \"AccelerationProfile\" \"-1\"
  Option \"Australian Scrolling\" \"1\"
  Option \"Fling To Scroll Enabled\" \"0\"
  Option \"Pointer Sensitivity\" \"3\"
  Option \"Pressure Calibration Slope\" \"3.1416\"
  Option \"Scroll Sensitivity\" \"0\"
  Option \"Scroll X Out Scale\" \"0.02\"
  Option \"Scroll Y Out Scale\" \"0.005\"
  Option \"Tap Drag Enable\" \"1\"
  Option \"Tap Minimum Pressure\" \"10\"
  Option \"Two Finger Scroll Distance Thresh\" \"0\"
  Option \"Zero Finger Click Enable\" \"0\"
EndSection
")

(operating-system
 (host-name %%host)
 (timezone "Europe/Prague")
 (locale "en_US.utf8")

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")))

 (kernel my-linux)

 ; see `filefrag -v /swap`
 ;(kernel-arguments (list "resume=UUID=f6c1927d-1570-4465-998c-172131891af3" "resume_offset=1454080"))

 (firmware (append (list my-firmware) %base-firmware)) ; my-skylake causes DMAR error

 (initrd-modules (append (list "mmc_block" "sdhci-pci") %base-initrd-modules))

 (file-systems
  (cons* (file-system
          (device (file-system-label "root"))
          (mount-point "/")
          (type "ext4"))
         (file-system
          (device (file-system-label "EFI"))
          (mount-point "/boot/efi")
          (type "vfat"))
         (file-system
          (device (file-system-label "data"))
          (mount-point "/data")
          (type "ext4"))
         %base-file-systems))

 (swap-devices (list "/swap"))

 (users
  (cons (user-account
         (name %%user)
         (group "users")
         (supplementary-groups
           (list "audio" "kvm" "lp" "netdev" "video" "wheel"))
         (home-directory %%home))
        %base-user-accounts))

 (issue "")

 (sudoers-file (plain-file "sudoers"
                           "root ALL=(ALL) ALL
%wheel ALL=(ALL) ALL
b ALL=NOPASSWD: /home/b/bin/0hoot, /home/b/.guix-profile/bin/bluetoothctl, /run/current-system/profile/bin/cmst, /run/current-system/profile/bin/connmanctl
")) ; newline!

 (setuid-programs
  (cons* #~(string-append #$slock "/bin/slock")
         %setuid-programs))

 (packages
  (cons* my-cmt
         cmst
         ;cups
         cwm
         libvdpau-va-gl
         nss-certs
         xf86-video-intel
         %base-packages))

 (services
  (cons* (bluetooth-service)
         (console-keymap-service (string-append %%home "/cfg/hsnt.map.gz"))
         (dbus-service)
         (ntp-service
          #:servers (list "0.europe.pool.ntp.org"
                          "1.europe.pool.ntp.org"
                          "2.europe.pool.ntp.org"
                          "3.europe.pool.ntp.org"))
         (polkit-service)
         (slim-service
          #:default-user %%user
          #:auto-login? #t
          #:startx
          (xorg-start-command
            #:configuration-file
            (xorg-configuration-file
              #:modules my-xorg-modules
              #:extra-config (list my-xorg-config))))
         (service connman-service-type)
         ;(service cups-service-type
         ;         (cups-configuration
         ;           (web-interface? #t)
         ;           (default-paper-size "A4")))
         (service mcron-service-type)
         (service rottlog-service-type (rottlog-configuration))
         (service sysctl-service-type
           (sysctl-configuration
             (settings '(("vm.swappiness" . "10")
                         ("vm.vfs_cache_pressure" . "50")
                         ("vm.dirty_background_ratio" . "5")
                         ("vm.dirty_ratio" . "50")))))
         (service wpa-supplicant-service-type)
         (simple-service 'mtp udev-service-type (list libmtp))
         (remove (lambda (service)
                   (eq? (service-kind service) console-font-service-type))
                 %base-services)))

 (name-service-switch %mdns-host-lookup-nss))
