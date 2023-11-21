@echo off
setlocal enabledelayedexpansion
set "scriptDir=%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "!scriptDir!scripts\convert_to_gif.ps1"
pause