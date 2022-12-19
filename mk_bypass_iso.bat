@echo off
setlocal
REM German
chcp 1252
REM 
REM Version 1.2
REM 
openfiles > NUL 2>&1 
if NOT %ERRORLEVEL% EQU 0 goto NotAdmin 
goto StartMain
:NotAdmin 
echo Sie müssen das Script als Administrator starten
goto error

:StartMain
if /i "%~1"=="" goto usage
SET ISOFILENAME=%~1

REM Bei Bedarf anpassn
SET VOLID="Win11"
SET ISONAME="Windows_11_bypass.iso"

if not exist "ISO" mkdir ISO
if not exist "WIM" mkdir WIM

if exist "ISO\sources\boot.wim" (
echo "ISO\sources\boot.wim ist bereits vorhanden."
echo "Bitte löschen Sie das Verzeichnis ISO."
goto end
)

echo ISO extrahieren
7z x -y %ISOFILENAME% -oISO
if %errorlevel% neq 0 goto error


echo boot.wim einhängen
dism /Mount-Image /Imagefile:"ISO\sources\boot.wim" /Index:2 /MountDir:WIM
if %errorlevel% neq 0 goto error
echo Registry-Hive laden
reg load HKLM\Z "WIM\Windows\System32\config\SYSTEM"
echo Registry-Import
reg import bypass.reg
echo Registry-Hive unload
reg unload HKLM\Z
echo Änderungen in boot.wim speichern
Dism /Unmount-image /MountDir:WIM /Commit
REM Aufräumen
dism /Get-MountedImageInfo
dism /cleanup-mountpoints
dism /cleanup-wim
dism /Get-MountedImageInfo
:mkiso
mkisofs.exe -iso-level 4 -udf -r -force-uppercase -duplicates-once -volid %VOLID% -hide boot.catalog -hide-udf boot.catalog -b "boot/etfsboot.com" -no-emul-boot -boot-load-size 8 -eltorito-platform efi -b "efi/microsoft/boot/efisys.bin" -no-emul-boot -o %ISONAME% ISO

goto endok

:usage
echo Erstellt ISO-Datei fuer Windows 11 mit Hardware-Bypass
echo.
echo mk_bypass_iso.bat ISO-Datei
echo.
goto end

:endok
echo Fertig
goto end
:error
REM aufräumen
echo "Abbruch: Es ist ein Fehler aufgetreten: %errorlevel%"
dism /cleanup-mountpoints
dism /cleanup-wim

:end
endlocal
