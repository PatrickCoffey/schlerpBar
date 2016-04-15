#!/bin/bash

# source config
. $(dirname $0)/../lb_config

trap 'trap - TERM; kill 0' INT TERM QUIT EXIT

# set up fifo
[ -e "${panel_fifo_disk}" ] && rm "${panel_fifo_disk}"
mkfifo "${panel_fifo_disk}"

# Conky, "SYS"
conky -c $(dirname $0)/lb_disk_conky > "${panel_fifo_disk}" &

# Panel 
PW=200
PH=48
PX=2155
PY=36

cat "${panel_fifo_disk}" | \
$(dirname $0)/lb_parser_disk.sh | \
lemonbar -f "${font}" -f "${iconfont}" -f "${iconfont2}" -g ${PW}x${PH}+${PX}+${PY} -B "${color_back}" -F "${color_fore}" -dp | sh
