#!/bin/bash
#Bitscout project
#Copyright Kaspersky Lab

. ./scripts/functions

statusprint "Installing forensics packages in chroot.."
case $GLOBAL_RELEASESIZE in
 1)
   chroot_exec build.$GLOBAL_BASEARCH/chroot 'DEBIAN_FRONTEND=noninteractive;
aria2c(){ /usr/bin/aria2c --console-log-level=warn "$@";}; export -f aria2c;
apt-fast --yes install coreutils hexedit' || exit 1
   ;;
 2)
   chroot_exec build.$GLOBAL_BASEARCH/chroot 'DEBIAN_FRONTEND=noninteractive;
aria2c(){ /usr/bin/aria2c --console-log-level=warn "$@";}; export -f aria2c;
apt-fast --yes install coreutils dcfldd sleuthkit hexedit indent' || exit 1
   ;;
 3)
   chroot_exec build.$GLOBAL_BASEARCH/chroot 'export DEBIAN_FRONTEND=noninteractive;
aria2c(){ /usr/bin/aria2c --console-log-level=warn "$@";}; export -f aria2c;
apt-fast --yes install coreutils dcfldd sleuthkit forensics-all indent
apt-fast --yes install aircrack-ng bfbtester binwalk bruteforce-luks bzip2 cabextract chntpw clamav cmospwd crunch cryptmount dcfldd disktype dnsutils ethstatus ethtool exfat-fuse exfat-utils exif exiftags libimage-exiftool-perl exiv2 fatcat fdupes flasm foremost gdisk geoip-bin  hexedit hydra john less  mc mdadm medusa memstat mpack nasm neopi netcat nmap ntfs-3g ophcrack-cli outguess p7zip-full parted pcapfix pdfcrack poppler-utils pecomato pev pyrit rarcrack samdump2 sipcrack smb-nat snowdrop stegsnow sucrack sxiv tcpdump tcpflow tcpick tcpreplay tcpxtract telnet testdisk tshark uni2ascii unrar-free unzip weplab whois wifite gdb' || exit 1
   ;;
esac

exit 0;
