#!/bin/bash

input=$1

declare -a addresses
declare -a cpu_last
declare -a cpu_last_sum
declare -a cpu_usage

# read in the list of addresses to ssh in
i=0
while IFS= read -r line; do
    addresses[$i]=$line
    i=$i+1
done <"$input"

while :; do
    for i in "${!addresses[@]}"; do

        # Get the first line with aggregate of all CPUs
        cpu_now=($(ssh ${addresses[$i]} head -n1 /proc/stat))

        # Get all columns but skip the first (which is the "cpu" string)
        cpu_sum="${cpu_now[@]:1}"
        # Replace the column seperator (space) with +
        cpu_sum=$((${cpu_sum// /+}))
        # Get the delta between two reads
        cpu_delta=$((cpu_sum - cpu_last_sum[$i]))
        # Get the idle time Delta
        cpu_idle=$((cpu_now[4] - cpu_last[$i]))
        # Calc time spent working
        cpu_used=$((cpu_delta - cpu_idle))
        # Calc percentage
        cpu_usage[$i]=$((100 * cpu_used / cpu_delta))

        # Keep this as last for our next read
        cpu_last[$i]="${cpu_now[4]}"
        cpu_last_sum[$i]=$cpu_sum
    done

    # print the results
    for i in "${!addresses[@]}"; do
        printf "${addresses[$i]}: ${cpu_usage[$i]}     \n"
    done

    # Wait a second before the next read
    sleep 1

    # clear the previous lines
    for i in "${!addresses[@]}"; do
        tput cuu1 # move cursor up by one line
    done

done
