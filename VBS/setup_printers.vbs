Option Explicit
Dim WshNetwork
Set WshNetwork = CreateObject("WScript.Network")

' Add printers
WshNetwork.AddWindowsPrinterConnection "\\ServerName\PrinterName"
WshNetwork.AddWindowsPrinterConnection "\\ServerName\PrinterName"

' Set Default
WshNetwork.SetDefaultPrinter "\\ServerName\PrinterName"

' Remove a printer
WshNetwork.RemovePrinterConnection "\\ServerName\PrinterName"