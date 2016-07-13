REM If you are killing all sesssions, just use:
REM net session /delete /y
REM This script is only useful for killing sessions of a given range

@echo off

REM Sets as follows (starting hosts last octet, increment, ending hosts last octet)
FOR /L %%i IN (2,1,28) DO (
  REM Kill each session without prompt
  net session \\192.168.1.%%i /delete /y
)