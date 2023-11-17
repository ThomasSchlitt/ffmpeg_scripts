@echo off
setlocal enabledelayedexpansion
REM This script takes a user input of an absolute path.
REM It finds all *.mp4, .avi, .mov files within that folder and converts each to a gif
REM 	Optionally, user can extend the end of the video
REM Results saved to subdirectory "gif"
REM ===========================================
REM  FUNCTION DECLARATION AREA
REM ===========================================
REM Function to create GIF from video
REM ===========================================
REM  MAIN ROUTINE
REM ===========================================
REM Set the frame rate for saving the GIFs

SET SAVING_FRAMES_PER_SECOND=16
REM Main script
cls

REM Create a local environment
echo =============================================================
echo "       _  __    ____                          _            "
echo "  __ _(_)/ _|  / ___|___  _ ____   _____ _ __| |_ ___ _ __ "
echo " / _` | | |_  | |   / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__|"
echo "| (_| | |  _| | |__| (_) | | | \ V /  __/ |  | ||  __/ |   "
echo " \__, |_|_|    \____\___/|_| |_|\_/ \___|_|   \__\___|_|   "
echo " |___/                                                     "
echo =============================================================
echo Author: Thomas Schlitt
echo Date: 10/10/2023
echo Wrapper utility to FFmpeg that converts select file types in the supplied directory to GIF.
echo File types supported: [.mp4, .mov, .avi]
echo Current Target Frame Rate: %SAVING_FRAMES_PER_SECOND%
echo =============================================================
echo.
echo Please provide the absolute path to the folder in which to search for *.mp4, *.mov, and *.avi files:

setlocal DisableDelayedExpansion
set /p "fdir=> "  
setlocal EnableDelayedExpansion

echo Indicate if you would like a pause at the end of the .gif before repeat. Units = second; Empty response = 0 sec pause:
set /p "pause_duration=> " 
REM set "pause_duration=2"

REM Check if the path is valid
if not exist !fdir! (
    echo "%fdir%"
    echo Invalid path supplied. Exiting sub-routine.
    pause
    exit /b
)

REM Create the "gifs" output folder if it doesn't exist
set "sdir=%fdir%\gifs"
if not exist "%sdir%\" mkdir "%sdir%"

REM create lists to store names and paths
set "vid_names="
set "file_paths="


REM search for AVI, MOV, MP4 file types
echo Beginning file rendering:
set "i=1"
REM for /r "%fdir%" %%A in (*.avi *.mov *.mp4) do (
for %%A in ("%fdir%\*.avi" "%fdir%\*.mov" "%fdir%\*.mp4") do (
	set "vid_name=%%~nA"
	echo      !i!.!vid_name!
	set /a "i+=1"
	
	set "input_name=%%A"
	
	set "output_fname=!sdir!\%%~nA.gif"
	call :create_gif !input_name!,!output_fname!,!pause_duration!, !SAVING_FRAMES_PER_SECOND! >nul 2>&1	
)	
set /a "i-=1"
echo Successfully converted !i! video files!

endlocal
pause
EXIT /B %ERRORLEVEL%

:create_gif
	set "fdir=%~dp2"
	set "palette_file=!fdir!palette.png"

	set "input_fname=%~1"
	set "output_fname=%~2"
	set "pause_duration=%~3"
	set "fps=%~4"

	REM echo INPUT FNAME: !input_fname!
	REM echo OUTPUT FNAME: !output_fname!
	REM echo PAUSE DURATION: !pause_duration!
	
	REM exit /b
	echo PALETTE FILE: !palette_file!
	REM echo ffmpeg -i !input_fname! -pix_fmt yuv420p -vf "palettegen" "!palette_file!"
	ffmpeg -i !input_fname! -pix_fmt yuv420p -vf "palettegen" "!palette_file!"
	
	if !pause_duration! gtr 0 ( 
		for %%F in (!input_fname!) do (
			set "directory=%%~dpF"
			set "filename=%%~nF"
			set "extension=%%~xF"
		)
		REM Append "extended" to the filename
		set "new_filepath=!directory!!filename!_extended!extension!"
		
		REM Only extend if extension has not already been performed
		if not exist !new_filepath! (
			ffmpeg -i "!input_fname!" -vf tpad=stop_mode=clone:stop_duration=!pause_duration! -q:v 0 "!new_filepath!"
		)
		set "input_fname=!new_filepath!"       
	)
	ffmpeg -i "!input_fname!" -i "!palette_file!" -lavfi "[0:v][1:v] paletteuse" -r !fps! "!output_fname!"
	REM Clean up palette file
	del "!palette_file!"
	EXIT /B 0
