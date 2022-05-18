#!/usr/bin/osascript
# @raycast.title Dislike & Next
# @raycast.author Nikodem   
# @raycast.description Eww! Next

# Required parameters:
# @raycast.icon images/apple-music-logo.png
# @raycast.schemaVersion 1
# @raycast.mode silent

tell application "Music"
    	if player state is playing then 
            set disliked of current track to true
            next track
            do shell script "echo Playing music"
        end if
end tell

