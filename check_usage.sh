#!/usr/bin/sh
#
# script checking CPU and memory utilization by user
#
cores=$(nproc)
clear
while true
do
  tput cup 0 0
  tput el
  tput el1
  echo -e "USER\t\t%CPU\t\t%MEM"
  # main loop
  for user in `ps -ef | grep -v UID | awk '{print $1}'| sort | uniq | awk '/^[^0-9,+]+[^\+]$/ {print $1}'`;
  do
    top -b -n 1 -u $user | awk -v var="$user" -v core=$cores 'NR>7 { sumC += $9; }; { sumM += $10; } END { print var "\t\t" sumC/core "\t\t" sumM; }';
  done | sort -n `echo $var` | tee /dev/tty | awk -v MM=$pmem 'NR>0 { sumCPU += $2}; { sumMem += $3} END { print "TOTAL\t\t" sumCPU "\t\t" MM*100; }'
  sleep 5
  tput cup 0
done
