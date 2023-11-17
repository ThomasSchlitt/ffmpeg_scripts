@echo off
echo "-------------------------------------------------------------------"
echo " ___  ___        __   ___  __      __   __   __     __  ___  __    "
echo "|__  |__   |\/| |__) |__  / _`    /__` /  ` |__) | |__)  |  /__`   "
echo "|    |     |  | |    |___ \__>    .__/ \__, |  \ | |     |  .__/   "
echo "-------------------------------------------------------------------"
echo This script appends the ffmpeg utilites to your user path.
where ffmpeg > nul 2>&1
rem If the "where" command succeeds (i.e., "ffmpeg" is found), exit the script
if %errorlevel% equ 0 (
    echo.
	echo.
	echo "ffmpeg" utilities are already in the PATH. Exiting Installation script.
	pause
    exit /b 0
)
setlocal enabledelayedexpansion
set "scriptDir=%~dp0"
powershell.exe -ExecutionPolicy Bypass -File "!scriptDir!path_modification.ps1"
pause