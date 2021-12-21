# Win11Bypass
Bypass Windows 11 hardware restrictions (new install)

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
