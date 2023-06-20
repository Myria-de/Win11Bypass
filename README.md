# Win11Bypass
Bypass Windows 11 hardware restrictions (new install)

Eine neue ISO-Datei für die Neuinstallation von Windows 11 auf beliebiger Hardware erstellen.

Verwendung: mk_bypass_iso.bat ISO-File

Das Bash-Script mk_Win11_bypass.sh aus dem Ordner "Linux" arbeitet unter Linux (Ubuntu/Linux Mint) entsprechend. Beachten Sie die Kommentare in der Datei und installieren Sie die nötogen Tools/Pakete.

**Credits:** 
- mkisofs.exe basiert auf den cdrtools von Jörg Schilling (https://schilytools.sourceforge.net). Es sind Patches von Alex Kopylov enthalten (ursprünglich von bootcd.ru, inzwischen offline).
- 7z.dll und 7z.exe stammen von https://www.7-zip.org

**Die Batch-Datei muss in einer Eingabeaufforderung mit administrativen Rechten gestartet werden.**

**Changelog Version 1.2:** 

- bessere Behandlung von Fehlern in mk_bypass_iso.bat 
- Neue Option "SET USEREG=" bei "yes" werden die Registry-Patches in die Registry der boot.wim eingetragen. Bei "no" werden die Patches über die Datei unattend_x64.xml angewandt (bitte vorher anpassen, siehe Kommentare in der XML-Datei), die als Autounattend.xml in das ISO kopiert wird. 

Die Batch-Datei extrahiert das ISO mit 7z in den Ordner "ISO". Danach wird die Datei boot.wim unter "WIM" eingehängt und der Registry-Zweig "WIM\Windows\System32\config\SYSTEM" geladen.

In die Registry werden dann diese Daten importiert:

```
Windows Registry Editor Version 5.00

[HKEY_LOCAL_MACHINE\Z\Setup\LabConfig]
"BypassTPMCheck"=dword:00000001
"BypassSecureBootCheck"=dword:00000001
"BypassRAMCheck"=dword:00000001
"BypassStorageCheck"=dword:00000001
"BypassCPUCheck"=dword:00000001
"BypassDiskCheck"=dword:00000001
```
Anschließend wird die boot.wim gespeichert und wieder ausgehängt.

Die neue ISO-Datei wird dann mit
```
mkisofs.exe -iso-level 4 -udf -r -force-uppercase -duplicates-once -volid "Win11" -hide boot.catalog -hide-udf boot.catalog -b "boot/etfsboot.com" -no-emul-boot -boot-load-size 8 -eltorito-platform efi -b "efi/microsoft/boot/efisys.bin" -no-emul-boot -o Windows_11_bypass.iso ISO
```

erstellt

Wer die Reg-Datei nach dem Booten von einer Standard-ISO-Datei verwenden will, benutzt die Datei bypass_standard_system.reg. Speichern Sie diese auf einem USB-Stick

Die lässt sich Installationssystem über eine Eingabeaufforderung (Shift-F10) importieren. Tippen Sie Notepad ein und bestätigen Sie mit der Enter-Taste. In Notepad geben Sie auf "Datei -> Öffnen", Hinter "Dateityp" stellen Sie "Alle Dateien" ein und navigieren zu dem Ordner, in dem Sie bypass_standard_system.reg gespeichert haben. Wählen Sie im Kontextmenü der reg-Datei "Zusammenführen".

**Hinweis:** In aktuellen Windows-11-Versionen sind nur die Registry-Werte BypassSecureBootCheck, BypassRAMCheck und BypassTPMCheck in der Datei Winsetup.dll nachweisbar. Die drei genügen offenbar, um auch den CPU-Check zu umgehen. Aber sicherheitshalber sollte man trotzdem weiterhin alle genannten Registry-Werte verwenden.

## Automated English translation:

Create a new ISO file for installing Windows 11 on any hardware.

Usage: mk_bypass_iso.bat ISO_File

The batch file must be started in a command prompt with administrative rights.

The bash script mk_Win11_bypass.sh from the folder "Linux" works accordingly under Linux (Ubuntu/Linux Mint). Note the comments in the file and install the necessary tools/packages.

**Changelog version 1.2:**

- better handling of errors in mk_bypass_iso.bat
- New option "SET USEREG=". With "yes" the registry patches are entered into the registry of boot.wim. At "no" the patches are applied via the file unattend_x64.xml (please adjust before, see comments in the XML file), which is copied to the ISO as autounattend.xml.

The batch file extracts the ISO with 7z into the folder "ISO". Then the file boot.wim is mounted under "WIM" and the registry branch "WIM\Windows\System32\config\SYSTEM" is loaded.

These data are then imported into the Registry:

Windows Registry Editor Version 5.00
```
[HKEY_LOCAL_MACHINE\Setup\LabConfig]
"BypassTPMCheck"=dword:00000001
"BypassSecureBootCheck"=dword:00000001
"BypassRAMCheck"=dword:00000001
"BypassStorageCheck"=dword:00000001
"BypassCPUCheck"=dword:00000001
"BypassDiskCheck"=dword:00000001
```
The boot.wim will be saved and unmounted.

The new ISO file is then created with

mkisofs.exe -iso-level 4 -udf -r -force-uppercase -duplicates-once -volid "Win11" -hide boot.catalog -hide-udf boot.catalog -b "boot/etfsboot.com" -no-emul-boot -boot-load-size 8 -eltorito-platform efi -b "efi/microsoft/boot/efisys.bin" -no-emul-boot -o Windows_11_bypass.iso ISO

If you want to use a reg file after booting from a standard ISO file, use the bypass_standard_system.reg file. Save it on a USB stick

The can be imported in the installation system via a command prompt (Shift-F10). Type Notepad and confirm with the Enter key. In Notepad type "File -> Open", behind "File type" set "All files" and navigate to the folder where you saved bypass_standard_system.reg. Select "Merge" in the context menu of the reg file.

Note: In current Windows 11 versions, only the registry values BypassSecureBootCheck, BypassRAMCheck and BypassTPMCheck are detectable in the Winsetup.dll file. These three are apparently sufficient to bypass the CPU check as well. But to be safe, you should still use all the registry values mentioned.
