REM Simple addition of a network printer that is shared from a print server

REM Delete
rundll32 printui.dll PrintUIEntry /dn /n\\server.name.example\Printer-name /q

REM Add
rundll32 printui.dll PrintUIEntry /in /y /n\\server.name.example\Printer-name /q