(define-module (my packages)
  #:use-module (gnu packages linux)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix build-system trivial)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix packages))

(define-public my-firmware
  (package
   (name "my-firmware")
   (version "7518922bd5b98b137af7aaf3c836f5a498e91609")
   (source
    (origin
     (method git-fetch)
     (uri (git-reference
           (url "git://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git")
           (commit version)))
     (sha256 (base32 "1f1476pq7ihhr298x67y4l0i0sfhl1syysidf112mzcp8gz58qry"))))
   (build-system trivial-build-system)
   (arguments
    `(#:modules ((guix build utils))
      #:builder
      (begin
        (use-modules (guix build utils))
        (let* ((source (assoc-ref %build-inputs "source"))
               (fw-dir (string-append %output "/lib/firmware/"))
               (i915-dir (string-append fw-dir "/i915/"))
               (intel-dir (string-append fw-dir "/intel/")))
          (mkdir-p fw-dir)
          (mkdir-p i915-dir)
          (mkdir-p intel-dir)
          (for-each (lambda (file)
                      (copy-file file (string-append i915-dir (basename file))))
                    (find-files source "skl.*\\.bin$"))
          (for-each (lambda (file)
                      (copy-file file (string-append intel-dir (basename file))))
                    (find-files source "ibt-12-16.*"))
          (for-each (lambda (file)
                      (copy-file file (string-append fw-dir (basename file))))
                    (find-files source "iwlwifi-.*\\.ucode$"))
          (for-each (lambda (file)
                      (copy-file file (string-append fw-dir (basename file))))
                    (find-files source (string-append
                                        "LICENSE\\.i915$"
                                        "|LICENCE\\.ibt_firmware$"
                                        "|LICENSE\\.iwlwifi_firmware$")))
          #t))))
   (home-page "https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi")
   (synopsis "linux firmware nonfree")
   (description "linux firmware nonfree")
   (license (license:non-copyleft "https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/tree/LICENSE.iwlwifi_firmware?id=HEAD"))))

(define-public my-linux
  (package
   (inherit linux-libre)
   (name "my-linux")
   (version "4.16.11")
   (source
    (origin
     (method url-fetch)
     (uri '("https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.16.11.tar.xz"))
     (sha256 (base32 "088931hgi5acm8nz19nd09skmamr3hhfb958374j30br6f94pfkd"))))
   ;(native-inputs
   ;  `(("kconfig" ,(local-file "/data/opt/kernel-4_15_7.config"))
   ;    ,@(alist-delete "kconfig" (package-native-inputs linux-libre))))
   ;(inputs
   ;  `(("libelf" ,libelf)
   ;    ,@(package-inputs linux-libre)))
   ))

(use-modules (gnu) (srfi srfi-1))
(use-system-modules nss)
(use-service-modules admin dbus mcron networking xorg)
(use-package-modules certs samba xorg wm)

(define %%user "b")
(define %%host "c")
(define %%home (string-append "/home/" %%user))

(operating-system
 (host-name %%host)
 (timezone "Europe/Prague")
 (locale "en_US.utf8")

 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (target "/boot/efi")))

 (kernel my-linux)

 (firmware (append (list my-firmware) %base-firmware))

 (initrd-modules (append '("shpchp") %base-initrd-modules))

 (file-systems
  (cons* (file-system
          (device (file-system-label "root"))
          (mount-point "/")
          (type "ext4"))
         (file-system
          (device (file-system-label "boot"))
          (mount-point "/boot/efi")
          (type "vfat"))
         (file-system
          (device (file-system-label "data"))
          (mount-point "/data")
          (type "ext4"))
         %base-file-systems))

 (swap-devices '("/swap"))

 (users
  (cons (user-account
         (name %%user)
         (group "users")
         (supplementary-groups '("audio" "netdev" "video" "wheel"))
         (home-directory %%home))
        %base-user-accounts))

 (sudoers-file (local-file (string-append %%home "/cfg/sudoers")))

 (issue "")

 (packages
  (cons* cwm
         nss-certs
         xf86-video-intel
         %base-packages))

 (services
  (cons* ;(bluetooth-service)
         (console-keymap-service (string-append %%home "/cfg/hsnt.map.gz"))
         (dbus-service)
         (ntp-service
          #:servers '("0.europe.pool.ntp.org"
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
            #:extra-config '("
Section \"Device\"
  Identifier \"intel\"
  # requires xf86-video-intel
  Driver \"intel\"
  Option \"AccelMethod\" \"sna\"
  Option \"TearFree\" \"true\"
  Option \"DRI\" \"3\"
EndSection
Section \"InputClass\"
  Identifier \"touchpad\"
  MatchProduct \"DLL0704:01 06CB:76AE Touchpad\"
  Driver \"libinput\"
  Option \"AccelSpeed\" \"0.25\"
  Option \"ClickMethod\" \"clickfinger\"
  Option \"NaturalScrolling\" \"true\"
  Option \"Tapping\" \"true\"
EndSection"))))
         (wicd-service)
         ;(service mcron-service-type)
         ;(service rottlog-service-type)
         (remove (lambda (service)
                   (eq? (service-kind service) console-font-service-type))
                 %base-services)))

 (name-service-switch %mdns-host-lookup-nss))
