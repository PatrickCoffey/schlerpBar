#!/bin/bash

# source config
. $(dirname $0)/../lb_config

#trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# set up fifo
[ -e "${panel_fifo_wifi}" ] && rm "${panel_fifo_wifi}"
mkfifo "${panel_fifo_wifi}"

# Conky, "SYS"
conky -c $(dirname $0)/lb_wifi_conky > "${panel_fifo_wifi}" &

# Panel 
PW=300
PH=48
PX=1730
PY=36

cat "${panel_fifo_wifi}" | \
$(dirname $0)/lb_parser_wifi.sh | \
lemonbar -f "${font}" -f "${iconfont}" -f "${iconfont2}" -g ${PW}x${PH}+${PX}+${PY} -B "${color_back}" -F "${color_fore}" -pd | sh
