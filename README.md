# Win11Bypass
Bypass Windows 11 hardware restrictions (new install)

Eine neue ISO-Datei für die Neuinstallation von Windows 11 auf beliebiger Hardware erstellen.

Verwendung: mk_bypass_iso.bat ISO-File

Die Batch-Datei extrahiert das ISO mit 7z in den Ordner "ISO".

Danach wird die Datei boot.wim unter "WIM" eingehängt und der Registry-Zweig "WIM\Windows\System32\config\SYSTEM" geladen.

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
