# This script takes a user input of an absolute path.
# It finds all *.mp4, .avi, .mov files within that folder and converts each to a gif
# Optionally, the user can extend the end of the video
# Results are saved to the subdirectory "gifs"

# Function to create GIF from video
function Create-Gif {
    param (
        [string]$InputPath,
        [string]$OutputPath,
        [int]$PauseDuration,
        [int]$FramesPerSecond
    )

    $PaletteFile = Join-Path (Split-Path $OutputPath) "palette.png"
    
    # Generate palette file
    $ffmpeg_output = ffmpeg -i $InputPath -pix_fmt yuv420p -vf "palettegen" $PaletteFile  2>&1 > $null
	if ($LASTEXITCODE -ne 0) {
			Write-Host "Error while generating palette:"
			Write-Host $ffmpeg_output
			return 
		}
		
    # Extend video if specified
    if ($PauseDuration -gt 0) {
        $FileInfo = Get-Item $InputPath
        $NewFilePath = Join-Path $FileInfo.Directory.FullName "$($FileInfo.BaseName)_extended$($FileInfo.Extension)"
        
        # Only extend if extension has not already been performed
        if (-not (Test-Path $NewFilePath)) {
            $ffmpeg_output = ffmpeg -i $InputPath -vf "tpad=stop_mode=clone:stop_duration=$PauseDuration" -q:v 0 $NewFilePath   2>&1 > $null
        
			if ($LASTEXITCODE -ne 0) {
				Write-Host "Error while extending animation:"
				Write-Host $ffmpeg_output
				return 
			}
			
		}
        
        $InputPath = $NewFilePath
    }

    # Convert to GIF using the palette
    $ffmpeg_output = ffmpeg -i $InputPath -i $PaletteFile -lavfi "[0:v][1:v] paletteuse" -r $FramesPerSecond $OutputPath 2>&1 > $null
	
	if ($LASTEXITCODE -ne 0) {
				Write-Host "Error while extending animation:"
				Write-Host $ffmpeg_output
				return 
			}
    # Clean up palette file
    Remove-Item $PaletteFile
}

# Main script

Clear-Host
$env:SAVING_FRAMES_PER_SECOND = 16

Write-Host "============================================================="
Write-Host "       _  __    ____                          _            "
Write-Host "  __ _(_)/ _|  / ___|___  _ ____   _____ _ __| |_ ___ _ __ "
Write-Host " / _` | | |_  | |   / _ \| '_ \ \ / / _ \ '__| __/ _ \ '__|"
Write-Host "| (_| | |  _| | |__| (_) | | | \ V /  __/ |  | ||  __/ |   "
Write-Host " \__, |_|_|    \____\___/|_| |_|\_/ \___|_|   \__\___|_|   "
Write-Host " |___/                                                     "
Write-Host "============================================================="
Write-Host "Author: Thomas Schlitt"
Write-Host "Date: 11/21/2023"
Write-Host "Wrapper utility to FFmpeg that converts select file types in the supplied directory to GIF."
Write-Host "File types supported: [.mp4, .mov, .avi]"
Write-Host "Current Target Frame Rate: $env:SAVING_FRAMES_PER_SECOND"
Write-Host "============================================================="
Write-Host ""

# Set the frame rate for saving the GIFs
# Prompt user for the absolute path
Write-Host "Please provide the absolute path to the folder in which to search for *.mp4, *.mov, and *.avi files"
$fdir = Read-Host ">"

Write-Host "Indicate if you would like a pause at the end of the .gif before repeat. Units = second; Empty response = 0 sec pause:"
$pause_duration = Read-Host ">"
if ($pause_duration -eq ""){
	$pause_duration = 0
}

# Check if the path is valid
if (-not (Test-Path $fdir)) {
    Write-Host "$fdir"
    Write-Host "Invalid path supplied. Exiting script."
    pause
    exit
}

# Create the "gifs" output folder if it doesn't exist
$sdir = Join-Path $fdir "gifs"
if (-not (Test-Path $sdir)) {
    New-Item -ItemType Directory -Path $sdir | Out-Null
}

# Search for AVI, MOV, MP4 file types
Write-Host "Beginning file rendering:"
$i = 1
$extensions = "*.avi", "*.mov", "*.mp4"
Get-ChildItem -Path $fdir -Include $extensions -Recurse | ForEach-Object {
    $vid_name = $_.BaseName
    Write-Host "$i.$vid_name"
    $input_name = $_.FullName
    $output_fname = Join-Path $sdir "$($_.BaseName).gif"
    Create-Gif -InputPath $input_name -OutputPath $output_fname -PauseDuration $pause_duration -FramesPerSecond $env:SAVING_FRAMES_PER_SECOND
    $i++
}
