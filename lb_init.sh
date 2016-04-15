#! /bin/bash
#
# I3 bar with https://github.com/LemonBoy/bar

# source config
. $(dirname $0)/lb_config

# check if already running
#if [ $(pgrep -cx $(basename $0)) -gt 1 ] ; then
#    printf "%s\n" "The status bar is already running." >&2
#    exit 1
#fi

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# set up fifo
[ -e "${panel_fifo}" ] && rm "${panel_fifo}"
mkfifo "${panel_fifo}"


### EVENTS METERS

# Window title, "WIN"
xprop -spy -root _NET_ACTIVE_WINDOW | sed -un 's/.*\(0x.*\)/WIN\1/p' > "${panel_fifo}" &

# i3 Workspaces, "WSP"
# TODO : Restarting I2 breaks the IPC socket con. :(
$(dirname $0)/i3_ws.py > "${panel_fifo}" &

# Conky, "SYS"
conky -c $(dirname $0)/lb_conky > "${panel_fifo}" &

### UPDATE INTERVAL METERS
cnt_vol=${upd_vol}
cnt_xbl=${upd_xbl}

while :; do

  # Volume, "VOL"
  if [ $((cnt_vol++)) -ge ${upd_vol} ]; then
    amixer get Master | grep "${snd_cha}" | awk -F'[]%[]' '/%/ {if ($7 == "off") {print "VOL×\n"} else {printf "VOL%d%%\n", $2}}' > "${panel_fifo}" &
    cnt_vol=0
  fi

  # add birghtness to panel
  if [ $((cnt_xbl++)) -ge ${upd_xbl} ]; then
    printf "%s%s\n" "XBL" "$(xbacklight 2>&1 | head -c 4)" > "${panel_fifo}"
    cnt_xbl=0
  fi
  # Finally, wait 1 second
  sleep 1s;

done &

#### LOOP FIFO

cat "${panel_fifo}" | $(dirname $0)/lb_parser.sh | lemonbar -p -f "${font}" -f "${iconfont}" -f "${iconfont2}" -g "${geometry}" -B "${color_back}" -F "${color_fore}" | while read line; do eval $line; done

#cat "${panel_fifo}" | $(dirname $0)/lb_parser.sh

wait

