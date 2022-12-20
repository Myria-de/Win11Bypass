@echo off
setlocal enabledelayedexpansion
REM 
REM Version 1.2
REM 
REM *** Konfiguration ***
REM Bei Bedarf anpassen
SET VOLID="Win11"
SET ISONAME="Windows_11_bypass.iso"
REM Patches in die Registry eintragen
SET USEREG=yes
REM *ODER*
REM Patches anwenden und unbeaufsichtigte Installation
REM Bitte vorher unattend_x64.xml anpassen.
REM SET USEREG=no
REM *** Konfiguration Ende***

REM German charset
chcp 1252

openfiles > NUL 2>&1 
if NOT %errorlevel% EQU 0 goto NotAdmin 
goto StartMain
:NotAdmin 
echo Fehler: Sie müssen das Script als Administrator starten
goto end

:StartMain
if /i "%~1"=="" goto usage
SET ISOFILENAME=%~1

if "%USEREG%"=="no" (
 if not exist "unattend_x64.xml" (
  echo Fehler: Die Datei unattend_x64.xml fehlt.
  goto end
  )
)

if not exist "ISO" mkdir ISO
if not exist "WIM" mkdir WIM

if exist "ISO\sources\boot.wim" (
echo ISO\sources\boot.wim ist bereits vorhanden.
echo Bitte löschen Sie das Verzeichnis ISO.
goto end
)

echo ISO extrahieren
7z x -y %ISOFILENAME% -oISO
if %errorlevel% neq 0 goto error

if "%USEREG%"=="yes" (
echo boot.wim einhängen

dism.exe /Mount-Image /Imagefile:"ISO\sources\boot.wim" /Index:2 /MountDir:WIM
if !errorlevel! neq 0 goto error

echo Registry-Hive laden
reg load HKLM\Z "WIM\Windows\System32\config\SYSTEM"
if !errorlevel! neq 0 goto error
echo Registry-Import
reg import bypass.reg
echo Registry-Hive unload
reg unload HKLM\Z
echo Änderungen in boot.wim speichern
Dism /Unmount-image /MountDir:WIM /Commit
if !errorlevel! neq 0 goto error
REM Aufräumen
dism /Get-MountedImageInfo
dism /cleanup-mountpoints
dism /cleanup-wim
dism /Get-MountedImageInfo
) else (
REM Autounattend.xml, unbeaufsichtigte Installation
echo Kopierere unattend_x64.xml nach ISO\Autounattend.xml
copy unattend_x64.xml ISO\Autounattend.xml
)

:mkiso
echo Jetzt ist Gelegenheit, Dateien in den Ordner "ISO" hinzuzufügen.
pause
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
echo Abbruch: Es ist ein Fehler aufgetreten: %errorlevel%
:end
REM Aufräumen 
rmdir WIM
rmdir /S /Q ISO
endlocal
