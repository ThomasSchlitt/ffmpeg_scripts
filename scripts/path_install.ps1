# Get the current directory of the script
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition

# Define the subdirectory to be added to the path
$subdirectory = "ffmpeg\bin"

# Construct the full path to the subdirectory
$fullPath = Join-Path $scriptDir $subdirectory

# Check if the directory exists
Write-Host "Attempting to add ffmpeg to your path..."
if (Test-Path $fullPath) {
    # Add the subdirectory to the user's path
	$currentPath = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)
    [System.Environment]::SetEnvironmentVariable("PATH", "$currentPath;$fullPath", [System.EnvironmentVariableTarget]::User)

	#Reload the path
	$env:Path = [System.Environment]::GetEnvironmentVariable("PATH", [System.EnvironmentVariableTarget]::User)

    # Change console color to green
    Write-Host "Checking ffmpeg version..." -ForegroundColor Green
	$cmdCommand = 'ffmpeg -version'
	Write-Host '--------------------------------------------------------------------------------'
	$process = Start-Process cmd -ArgumentList "/c $cmdCommand | more " -PassThru -Wait -NoNewWindow
	
	if ($process.ExitCode -ne 0) {
		Write-Host "Error in setting the path. Please add the ffmpeg\bin folder to your system path manually" -ForegroundColor Red
		Exit 1
	}
	else {
		Write-Host "Path updated successfully." -ForegroundColor Green
	}
	Write-Host '--------------------------------------------------------------------------------'
}
else {
    # Display an error message in red
    Write-Host "The subdirectory does not exist: $fullPath" -ForegroundColor Red
}
