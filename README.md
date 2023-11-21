# Description
- Collection of scripts that wrap around the ffmpeg windows executable.
--------------------
# Installation:
1. Download/clone this repo to your local machine
2. Run "INSTALL.cmd" to append the ffmpeg\bin folder to your user-path
    - if errors occur, manually add the folder to your path
--------------------
# Usage:
- batch files in top-level directory will call powershell scripts in Scripts directory
	- powershell scripts will perform all operations for file creation + video editing
- double-click batch files (.cmd) to launch a command prompt window and follow text instructions
--------------------
# Known Issues:
- color space can be distorted if input video includes a very dense mesh:
    - lots of dark color may distort the generated color pallete during conversion
- anecdotally speaking, .avi with no compression (24 bits/pixel) tends to producebest color-representation in .gif
