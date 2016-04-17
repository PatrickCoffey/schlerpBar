#!/bin/bash

# config
. $(dirname $0)/lb_config

# min init
irc_n_high=0
title="${icon_prog}"

# parser
while read -r line ; do
  case $line in
    SYS*)
      # conky
      # 0 = wday, 1 = mday, 2 = month, 3 = time, 
      # 4 = cpu, 5 = mem, 6 = disk /, 7 = disk /home, 
      # 8 = battery status, 9 = bat %, 
      # 10 = wifi strength, 11 = download wifi, 12 = upload wifi 
      
      sys_arr=(${line#???})
      # date
      date_temp="${sys_arr[0]} ${sys_arr[1]} ${sys_arr[2]} "
      date="%{T2}${icon_clock}%{T1} ${date_temp}"
      # time
      time="${sys_arr[3]}"
      # wifi
      if [ ${sys_arr[10]} == "down" ]; then
          wifi="[%{T2}${icon_wifi_con} ${icon_wifi_dis}%{T1}]"
      else
          if [ ${sys_arr[10]//%} -lt 50 ]; then
              # low quality connection
              wifi="[%{T2}${icon_wifi_low}%{T1} ${sys_arr[10]}%]"
          elif [ ${sys_arr[10]//%} -lt 80 ]; then
              # medium connection
              wifi="[%{T2}${icon_wifi_mid}%{T1} ${sys_arr[10]}%]"
          else
              # strong connection
              wifi="[%{T2}${icon_wifi_hi}%{T1} ${sys_arr[10]}%]"
          fi
      fi
      # wifi uploads
      #wifi_ul="%{T2}${icon_ul}%{T1} ${sys_arr[12]} K"
      # wifi downloads
      #wifi_dl="%{T2}${icon_dl}%{T1} ${sys_arr[11]} K"
      # bat
      if [ "${sys_arr[8]}" == "C" ]; then
          bat="%{T2}${icon_bat_ac}%{T1} ${sys_arr[9]}"
      else
          bat="%{T2}${icon_bat_ac}%{T1} ${sys_arr[9]}"
          if [ ${sys_arr[9]//%} -lt 15 ]; then
              # battery low
              bat="%{T2}${icon_bat_low}%{T1} ${sys_arr[9]}"
          elif [ ${sys_arr[9]//%} -lt 50 ]; then
              # battery mid-low
              bat="%{T2}${icon_bat_low_mid}%{T1} ${sys_arr[9]}"
          elif [ ${sys_arr[9]//%} -lt 85 ]; then
              # battery hi-mid
              bat="%{T2}${icon_bat_mid_hi}%{T1} ${sys_arr[9]}"
          else
              # battery hi
              bat="%{T2}${icon_bat_hi}%{T1} ${sys_arr[9]}"
          
          fi
      fi
      # cpu
      cpu="[%{T2}${icon_cpu}%{T1} ${sys_arr[4]}%]"
      # mem
      mem="[%{T2}${icon_mem}%{T1} ${sys_arr[5]}]"
      # sys tasks
      task="[ %{T2}${icon_task}%{T1} ]"
      # disk /
      #diskr="%{T2}${icon_hd}%{T1} ${sys_arr[6]}%"
      diskr="%{T2}[${icon_hd}]%{T1}"
      # disk home
      #diskh="%{T2}${icon_home}%{T1} ${sys_arr[7]}%"
      ;;
    VOL*)
      # Volume
      vol="%{T2}${icon_vol}%{T1} ${line#???}"
      ;;
    XBL*)
      # X backlight
      xbl="%{T2}${icon_xbl}%{T1} ${line#???}"
      ;;
    WSP*)
      # I3 Workspaces
      wsp="%{T3}${icon_wsp}%{T1}${stab}"
      set -- ${line#???}
      while [ $# -gt 0 ] ; do
        case $1 in
         FOC*)
           wsp="${wsp} %{R} ${1#???} %{R}"
           ;;
         INA*|URG*|ACT*)
           wsp="${wsp} ${1#???}"
           ;;
        esac
        shift
      done
      ;;
    WIN*)
      # window title
      title=$(xprop -id ${line#???} | awk '/_NET_WM_NAME/{$1=$2="";print}' | cut -d'"' -f2)
      title=" ${title} "
      ;;
  esac

  # And finally, output
  printf "%s\n" "%{l}${wsp}${stab}${sep_right}${stab}%{R}${stab}${title}${stab}%{R}%{r}${sep_left}${stab}%{A:${act_cpu_c}:}${cpu}%{A}${stab}%{A:${act_mem_c}:}${mem}%{A}${stab}%{A:${act_task_c}:}${task}%{A}${stab}%{A:${act_disk_c}:}${diskr}%{A}${stab}%{A:${act_wifi_c}:}${wifi}%{A}${stab}${sep_left}${stab}%{A:${act_bat_c}:}${bat}%{A}${stab}${sep_left}${stab}%{A:${act_xbl_c}:}${xbl}%{A}${stab}${sep_left}${stab}%{A:${act_vol_c}:}${vol}%{A}${stab}${sep_left}${stab}%{A:${act_date_c}:}${date}${stab}${time}%{A}"

done
