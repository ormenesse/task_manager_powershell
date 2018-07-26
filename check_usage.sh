#!/usr/bin/sh
#
# script checking CPU and memory utilization by user
#
cores=$(nproc)
clear
while true
do
  tput cuu1
  echo ""
  echo -e "USER\t\t%CPU\t\t%MEM"
  
  # main loop

  for user in `ps -ef | grep -v UID | awk '{print $1}'| sort | uniq | awk '/^[^0-9,+]+[^\+]$/ {print $1}'`;
  do
    top -b -n 1 -u $user | awk -v var="$user" -v core=$cores 'NR>7 { sumC += $9; }; { sumM += $10; } END { print var "\t\t" sumC/core "\t\t" sumM; }';
  done | sort -n `echo $var`
  sleep 10
  tput cup 0
done
