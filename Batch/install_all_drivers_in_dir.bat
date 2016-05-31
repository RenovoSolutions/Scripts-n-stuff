REM Doesn't work very well with Windows 7 driver signing

for /r %%i in (*.inf) do pnputil.exe -i -a "%%i"