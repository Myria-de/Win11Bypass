#!/bin/bash
# nötige Pakete:
# Modus USEREG=1
# sudo apt install p7zip-full genisoimage wimtools libwin-hivex-perl

# Modus USEREG=0 (unattended)
# sudo apt install p7zip-full genisoimage
# Passen Sie für diesen Modus die Datei unattend_x64.xml an

[ ! -d ISO ] && mkdir ISO
[ ! -d WIM ] && mkdir WIM

if [ -z "$1" ] ; then
echo "Bitte Pfad und Namen der ISO-Datei angeben"
echo "Beispiel: ./mk_Win11_bypass.sh ~/Download/Win11.iso"
echo "oder im gleichen Verzeichnis: ./mk_Win11_bypass.sh Win11.iso"
exit 1
fi
USEREG=1
 if [ -z $(which 7z) ] ; then
  echo "7z nicht gefunden."
  echo "Installieren Sie das Paket p7zip-full."
  exit 1
 fi

 if [ -z $(which genisoimage) ] ; then
  echo "genisoimage nicht gefunden."
  echo "Installieren Sie das Paket genisoimage."
  exit 1
 fi


# ISO extrahieren
7z x -y $1 -oISO

if [ "$USEREG" == "1" ] ; then
#check prereq
 if [ -z $(which wimmountrw) ] ; then
  echo "wimmountrw nicht gefunden."
  echo "Installieren Sie das Paket wimtools."
  exit 1
 fi

 if [ -z $(which hivexregedit) ] ; then
  echo "hivexregedit nicht gefunden."
  echo "Installieren Sie das Paket libwin-hivex-perl."
  exit 1
 fi

# Index 2 ist in der boot.wim in der Regel "Microsoft Windows Setup"
# Bei Problemen bitte mit 
# wiminfo ISO/sources/boot.wim
# prüfen
wimmountrw ISO/sources/boot.wim 2 WIM
hivexregedit --merge WIM/Windows/System32/config/SYSTEM --prefix 'HKEY_LOCAL_MACHINE\SYSTEM' bypass.reg
wimunmount WIM --commit
sleep 10
else
 if [ -e "unattend_x64.xml" ] ; then
  cp unattend_x64.xml ISO/Autounattend.xml
 else
  echo "unattend_x64.xml fehlt. Abbruch"
  exit 1
 fi
fi

genisoimage -b "boot/etfsboot.com" -allow-limited-size --no-emul-boot --eltorito-alt-boot -b "efi/microsoft/boot/efisys.bin" --no-emul-boot --udf -iso-level 3 --hide "*" -V "Win11" -o "Windows_11_bypass.iso" ISO

