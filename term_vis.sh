#!/bin/bash

# Show 1 agent if no arg given
num_agents=$1
if [ -z "$num_agents" ];then
    num_agents=1
fi

term_col=`tput cols`
term_lines=`tput lines`

trap "tput cnorm; exit" SIGHUP SIGINT SIGTERM
tput civis


scale=1
if [ "$num_agents" == "1" ];then
    (( scale = 3 ))
elif [ "$num_agents" == "2" ];then
    (( scale = 2 ))
elif [ "$num_agents" == "3" ];then
    (( scale = 1.5 ))
elif [ "$num_agents" == "4" ];then
    (( scale = 1.25 ))
fi

(( game_width  = 160 * scale ))
(( game_height = 210 * scale ))



(( x_offset = 28 ))
(( y_offset = 72 ))


# clear spot for agents
for ((i=0; i<=$term_lines/2; i++)); do echo -e "\n"; done


# draw agents

# Press "1" to switches to low-speed updates (for SSH)

(( fps = 60 ))

for (( ; ; ))
do

   if [ "$fps" == "60" ];then
      read -t 0.0167 -r -s -n 1 input
   else
      read -t 0.5 -r -s -n 1 input
   fi

   if [ "$input" == "1" ];then
      if [ "$fps" == "60" ];then
         (( fps = 2 ))
      else
         (( fps = 60 ))
      fi
   fi

   for (( i=0; i<num_agents; i++ ))
   do
      if [ -f /tmp/universe$i.bmp ]; then
         ((x = x_offset + i * (game_width + x_offset) )) 
         mv /tmp/universe$i.bmp /tmp/back-universe$i.bmp

         echo -e "0;1;${x};${y_offset};${game_width};${game_height};0;0;0;0;/tmp/back-universe${i}.bmp\n3;" | /usr/lib/w3m/w3mimgdisplay

      fi
   done


done
