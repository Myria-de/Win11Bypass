# Win11Bypass
Bypass Windows 11 hardware restrictions (new install)

Eine neue ISO-Datei für die Neuinstallation von Windows 11 auf beliebiger Hardware erstellen.

**Verwendung:** mk_bypass_iso.bat ISO-File

Oder laden Sie [Win 11 Bypass (GUI)](https://github.com/Myria-de/Win11Bypass/releases/download/v1.2/Win11Bypass_v1.2.zip) herunter.

Das Bash-Script mk_Win11_bypass.sh aus dem Ordner "Linux" arbeitet unter Linux (Ubuntu/Linux Mint) entsprechend. Beachten Sie die Kommentare in der Datei und installieren Sie die nötigen Tools/Pakete.

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

## Win11Bypass-GUI
Laden Sie Win11Bypass_v1.2.zip (https://github.com/Myria-de/Win11Bypass/releases/download/v1.2/Win11Bypass_v1.2.zip) herunter. Starten Sie Win11Bypass.exe und wählen Sie die Original-ISO-Datei von Windows 11 aus. Klicken Sie auf "Antwortdatei anpassen" und tragen Sie den Benutzernamen für ein lokales Konto und ein Passwort ein. Vergeben Sie außerdem einen Namen für den Rechner und die Netzwerk-Arbeitsgruppe. Für Letztere tragen Sie *Workgroup* ein, wenn Sie in Ihrem Netzwerk nichts anderes verwenden. Klicken Sie auf „Datei speichern“ und dann auf „ISO-Datei erstellen“.

Win 11 Bypass extrahiert den Inhalt der ISO-Datei, baut die Antwortdatei für die automatische Installation ein und pausiert dann. Bei Bedarf haben Sie dadurch Gelegenheit, weitere Dateien in den Ordner "Win11Bypass\Tools\Bypass\ISO" zu kopieren, etwa Setup-Programme für Treiber. Ist das erledigt, drücken Sie im Fenster der Eingabeaufforderung eine beliebige Taste. Anschließend wird die ISO-Datei mit dem Namen „Windows_11_bypass.iso“ erstellt. Verwenden Sie diese etwa auf einem mit Ventoy (https://www.ventoy.net) präparierten USB-Stick für die Neuinstallation von Windows 11.

Win 11 Bypass verwendet Reg- und Batch-Dateien aus dem Ordner "Tools/Bypass". Sie können die Dateien anpassen und damit die Funktionen des Tools beeinflussen.

**Inplace-Update:** Wenn Sie ein Funktionsupdate auf nicht offiziell unterstützter Hardware durchführen möchten, klicken Sie auf der Registerkarte "Win11-Bypass-ISO" auf "Reg-Datei importieren". Dafür müssen Sie kein angepasstes ISO erstellen. Sie können die Original-ISO-Datei von Microsoft für das Update verwenden. Binden Sie die ISO-Datei im Windows-Explorer über den Kontextmenüpunkt "Bereitstellen" in das Dateisystem ein und starten Sie Setup.exe.

<img width="575" height="553" alt="Win11Bypass" src="https://github.com/user-attachments/assets/fd815752-adbb-4657-aa6c-a7c1b7ba04d0" />

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
```
mkisofs.exe -iso-level 4 -udf -r -force-uppercase -duplicates-once -volid "Win11" -hide boot.catalog -hide-udf boot.catalog -b "boot/etfsboot.com" -no-emul-boot -boot-load-size 8 -eltorito-platform efi -b "efi/microsoft/boot/efisys.bin" -no-emul-boot -o Windows_11_bypass.iso ISO
```
If you want to use a reg file after booting from a standard ISO file, use the bypass_standard_system.reg file. Save it on a USB stick

The can be imported in the installation system via a command prompt (Shift-F10). Type Notepad and confirm with the Enter key. In Notepad type "File -> Open", behind "File type" set "All files" and navigate to the folder where you saved bypass_standard_system.reg. Select "Merge" in the context menu of the reg file.

Note: In current Windows 11 versions, only the registry values BypassSecureBootCheck, BypassRAMCheck and BypassTPMCheck are detectable in the Winsetup.dll file. These three are apparently sufficient to bypass the CPU check as well. But to be safe, you should still use all the registry values mentioned.

## Win11Bypass GUI
Download Win11Bypass_v1.2.zip (https://github.com/Myria-de/Win11Bypass/releases/download/v1.2/Win11Bypass_v1.2.zip). Launch Win11Bypass.exe and select the original Windows 11 ISO file. Click on  "Antwortdatei anpassen" ("Customise response file") and enter a username for a local account and a password. Also, assign a name for the computer and the network workgroup. For the latter, enter *Workgroup* if you do not use anything else on your network. Click on "Datei speichern" ("Save File") and then on "ISO-Datei erstellen" ("Create ISO File").

Win 11 Bypass extracts the contents of the ISO file, embeds the response file for automatic installation, and then pauses. If necessary, this gives you the opportunity to copy additional files into the ‘Win11Bypass\Tools\Bypass\ISO’ folder, such as driver setup programmes. Once this is done, press any key in the command prompt window. The ISO file will then be created with the name ‘Windows_11_bypass.iso’. Use this, for example, on a USB stick prepared with Ventoy (https://www.ventoy.net) to reinstall Windows 11.

Win 11 Bypass uses Reg and batch files from the ‘Tools/Bypass’ folder. You can customise the files to influence the tool’s functionality.

**In-place update:** If you wish to perform a feature update on hardware that is not officially supported, click on "Reg-Datei importieren" ("Import Reg file") in the ‘Win11-Bypass-ISO’ tab. You do not need to create a customised ISO for this. You can use the original ISO file from Microsoft for the update. Mount the ISO file in Windows Explorer using the ‘Mount’ context menu option and run Setup.exe.

