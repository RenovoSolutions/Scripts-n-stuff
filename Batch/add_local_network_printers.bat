REM These are still networked printers but are not served by a print server so they need local printer ports
REM Everything here should be available on XP and above I believe

REM /q flag skips errors, /n is name

REM Deletes the local printer
rundll32 printui.dll,PrintUIEntry /dl /q /n "Example-Printer"

REM Deletes the local printer ports
REM Two are used here, one for a color queue and one for black and white
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -d -r IP_192.168.1.200 -h 192.168.1.200
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -d -r IP_192.168.1.200_2 -h 192.168.1.200

REM Adds the local printer ports
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_192.168.1.200 -h 192.168.1.200
cscript c:\Windows\System32\Printing_Admin_Scripts\en-US\prnport.vbs -a -r IP_192.168.1.200_2 -h 192.168.1.200

REM Adds the local printers
REM For this particular example, we would of used some utility to place the driver files in the same location on each PC
REM The model name (/m) needs to match the driver model name
REM You can obtain this model name by manually adding one printer and looking at the Advanced tab in Printer Propeties
REM Where you see Driver: should have the correct name
rundll32 printui.dll,PrintUIEntry /if /q /b "Example-Printer" /f C:\ricoh_upd\oemsetup.inf /r "IP_192.168.1.200" /m "RICOH PCL6 UniversalDriver V4.9"
rundll32 printui.dll,PrintUIEntry /if /q /b "Example-Printer" /f C:\ricoh_upd\oemsetup.inf /r "IP_192.168.1.200_2" /m "RICOH PCL6 UniversalDriver V4.9"

REM Set default printer
rundll32 printui.dll,PrintUIEntry /y /n "Example-Printer"

REM Sets the local BW queues to saved settings
REM You will need to add a printer manually to a workstation, set the appropriate preferences then run:
REM rundll32 printui.dll,PrintUIEntry /Ss /n "Example-Printer-BW" /a "C:\ricoh_upd\example_bw.dat" u
REM This saves the preferences to a .dat file
REM Which is then called from the command below
rundll32 printui.dll,PrintUIEntry /Sr /q /n "Example-Printer" /a "C:\ricoh_upd\example_bw.dat" u