#!/usr/bin/env bash
RUNNING=$(osascript -e 'if application "Mail" is running then return 0')
COUNT=0

INDEX=$(yabai -m query --spaces --space | jq '.index')

if [ $RUNNING == 0 ]; then
  COUNT=$(osascript -e 'tell application "Mail" to return the unread count of inbox')
  LABEL=""
  if [ $COUNT == 0 ]; then
	LABEL="mail"
  else 
	LABEL="mail($COUNT)"
  fi 

  sketchybar --set $NAME label=$LABEL
  if [ $INDEX == 3 ]; then 
	  sketchybar --set $NAME icon.highlight=on
  else 
	  sketchybar --set $NAME icon.highlight=off
  fi
else
  sketchybar --set $NAME label=
fi

