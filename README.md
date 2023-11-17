# Description
- Collection of scripts that wrap around the ffmpeg windows executable.
--------------------
# Installation:
1. Download/clone this repo to your local machine
2. Run "INSTALL.cmd" to append the ffmpeg\bin folder to your user-path
    - if errors occur, manually add the folder to your path
--------------------
# Usage:
- scripts included in the 'scripts' directory should be active after installation
- double-click to launch a command prompt window and follow text instructions
--------------------
# Known Issues:
- absolute file path cannot contain special characters ( ! , ~ , # , etc...)
- color space can be distorted if input video includes a very dense mesh:
    - lots of dark color may distort the generated color pallete during conversion
- anecdotally speaking, .avi with no compression (24 bits/pixel) tends to producebest color-representation in .gif
