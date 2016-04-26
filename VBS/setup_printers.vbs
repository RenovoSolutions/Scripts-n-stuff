Option Explicit
Dim WshNetwork

Set WshNetwork = CreateObject("WScript.Network")

' Add printers
WshNetwork.AddWindowsPrinterConnection "\\server\printer"

' Set Default
WshNetwork.SetDefaultPrinter "\\print.ca.renovo.solutions\Accounts-Receivable-BW"

' Prevent hang ups if there is an error
ON ERROR RESUME NEXT

' Remove old printers (skips errors thanks to line above)
WshNetwork.RemovePrinterConnection "\\server\printer"

Msgbox "Your printers should now be available. You can delete your old printers.",0,"Printer Setup"