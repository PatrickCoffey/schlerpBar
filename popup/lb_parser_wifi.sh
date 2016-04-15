#!/bin/bash

# config
. $(dirname $0)/../lb_config

# min init
irc_n_high=0
title="${icon_prog}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky
      # 0 = download wifi, 1 = upload wifi 
      sys_arr=(${line#???})
      # wifi uploads
      wifi_ul="%{T2}${icon_ul}%{T1} ${sys_arr[1]} K"
      # wifi downloads
      wifi_dl="%{T2}${icon_dl}%{T1} ${sys_arr[0]} K"
      ;;
  esac

  # And finally, output
  printf "%s\n" "%{c} %{A1:${act_sub_c}:}${wifi_dl}${stab}${wifi_ul}%{A}"

done
