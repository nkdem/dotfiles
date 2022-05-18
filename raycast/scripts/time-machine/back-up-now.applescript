#!/usr/bin/osascript

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title Back Up Now
# @raycast.mode silent

# Optional parameters:
# @raycast.icon icon.png

# Documentation:
# @raycast.author Nikodem

do shell script "tmutil startbackup"