# Description
- Collection of scripts that wrap around the ffmpeg windows executable.
--------------------
# Contact Info
Author: Thomas Schlitt
Date: 11/17/2023
Email: tschlitt123@gmail.com
--------------------
# Known Issues:
- absolute file path cannot contain special characters ( ! , ~ , # , etc...)
- color space can be distorted if input video includes a very dense mesh:
    - lots of dark color may distort the generated color pallete during conversion
- anecdotally speaking, .avi with no compression (24 bits/pixel) tends to producebest color-representation in .gif
