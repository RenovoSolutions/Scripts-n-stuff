REM Checks for hosts file entry, if it doesn't exist, creates it.
REM Obviously replace 10.255.255.255 example.com with an appropriate entry.

@echo off

SET NEWLINE=^& echo.

FIND /C /I "qb" %WINDIR%\system32\drivers\etc\hosts
IF %ERRORLEVEL% NEQ 0 ECHO %NEWLINE%^10.255.255.255 example.com>>%WINDIR%\System32\drivers\etc\hosts