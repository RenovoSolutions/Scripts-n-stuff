' Should be performed BEFORE joining AD if this computer will be on a domain

' Create a continuous loop, if confirmation of entered name
' returns no then the loop restarts, otherwise is exits
Do While True
    ' Get hostname from user
    strHostname = InputBox("Please enter a name for this PC:", "PC Name")
    'Quit if no name is given or cancel is clicked
    If strHostname = "" Then
        Wscript.Quit
    Else
        ' We need to make sure no invalid characters are written to registry 
        ' Create a Regular expression object
        Set objRegEx = CreateObject("VBScript.RegExp")
        ' Make sure it searches globally in a string
        objRegEx.Global = True
        ' Set pattern, make sure it includes all valid characters for a name
        objRegEx.Pattern = "[^A-Za-z0-9\-_]"
        strHostname = objRegEx.Replace(strHostname, "")
        ' Confirm the name is correct after invalid characters are removed
        result = MsgBox (strHostname, 3, "Verify your hostname is correct:")
        Select Case result
        ' Rename if yes
        Case vbYes    
            ' Create a WSH Shell object:
            Set wshShell = CreateObject( "WScript.Shell" )

            ' Write name to registry entries
            wshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName", strHostname, "REG_SZ"
            wshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\ComputerName", strHostname, "REG_SZ"
            wshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName\ComputerName", strHostname, "REG_SZ"
            wshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Hostname", strHostname, "REG_SZ"
            wshShell.RegWrite "HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\NV Hostname", strHostname, "REG_SZ"

            Set WshShell = Nothing
            WScript.echo "Named " + strHostname " ... reboot to take effect."
            WScript.Quit
        ' Repeat if no
        Case vbNo
        ' Exit if cancel
        Case vbCancel
            WScript.Quit
        End Select
    End If
Loop