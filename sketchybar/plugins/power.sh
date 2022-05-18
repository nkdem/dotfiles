#!/usr/bin/env bash
BATT_PERCENT=$(pmset -g batt | grep -Eo "\d+%" | cut -d% -f1)
CHARGING=$(pmset -g batt | grep 'AC Power')

if [[ $CHARGING != "" ]]; then
  sketchybar -m --set $NAME \
    icon.color=0xFFA8CC76 \
    icon= \
    label=$(printf "${BATT_PERCENT}%%")
  exit 0
fi

[[ ${BATT_PERCENT} -gt 10 ]] && COLOR=0xFFA8CC76

case ${BATT_PERCENT} in
   100) ICON="" ;;
    9[0-9]) ICON="" ;;
    8[0-9]) ICON="" ;;
    7[0-9]) ICON="" ;;
    6[0-9]) ICON="" && COLOR=0xFFD9B072 ;;
    5[0-9]) ICON="" ;;
    4[0-9]) ICON="" ;;
    3[0-9]) ICON="" && COLOR=0xFFE77D8F ;;
    2[0-9]) ICON="" ;;
    1[0-9]) ICON="" ;;
    *) ICON=""
esac

sketchybar -m --set $NAME\
  icon.color=$COLOR \
  icon=$ICON \
  label=$(printf "${BATT_PERCENT}%%")
