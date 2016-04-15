#!/bin/bash

# config
. $(dirname $0)/../lb_config

# parser
while read -r line ; do
  case $line in
    SYS*)
      sys_arr=(${line#???})
      # disk home
      diskh="%{T2}${icon_home}%{T1} ${sys_arr[0]}%"
      ;;
  esac

  # And finally, output
  printf "%s\n" "%{c} %{A:${act_sub_c}:} ${diskh} %{A}"

done
