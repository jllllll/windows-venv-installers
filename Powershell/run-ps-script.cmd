@echo off

set SCRIPT_NAME=Install.ps1

@rem This will run the Powershell script named above in the current directory
@rem This is intended for systems who have not changed the script execution policy from default
@rem These systems will be unable to directly execute Powershell scripts unless done through CMD.exe like below

if not exist "%~dp0\%SCRIPT_NAME%" ( echo %SCRIPT_NAME% not found! && pause && goto eof )
call powershell.exe -executionpolicy Bypass ". '%~dp0\%SCRIPT_NAME%'"