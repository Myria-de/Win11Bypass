@echo off
setlocal
if /i "%~1"=="" goto usage
SET ISOFILENAME=%~1

if not exist "ISO" mkdir ISO
if not exist "WIM" mkdir WIM

echo ISO extrahieren
7z x -y %ISOFILENAME% -oISO"
echo boot.wim einhaengen
dism /Mount-Image /Imagefile:"ISO\sources\boot.wim" /Index:2 /MountDir:WIM
echo Registry-Hive laden
reg load HKLM\Z "WIM\Windows\System32\config\SYSTEM"
echo Registry-Import
reg import bypass.reg
echo Registry-Hive unload
reg unload HKLM\Z
echo Aenderungen in boot.wim speichern
Dism /Unmount-image /MountDir:WIM /Commit
dism /Get-MountedImageInfo
dism /cleanup-mountpoints
dism /cleanup-wim
dism /Get-MountedImageInfo
:mkiso
mkisofs.exe -iso-level 4 -udf -r -force-uppercase -duplicates-once -volid "Win11" -hide boot.catalog -hide-udf boot.catalog -b "boot/etfsboot.com" -no-emul-boot -boot-load-size 8 -eltorito-platform efi -b "efi/microsoft/boot/efisys.bin" -no-emul-boot -o Windows_11_bypass.iso ISO

goto end

:usage
echo Erstellt ISO-Datei fuer Windows 11 mit Hardware-Bypass
echo.
echo mk_bypass_iso.bat ISO-Datei
echo.

:end
echo Fertig
endlocal
