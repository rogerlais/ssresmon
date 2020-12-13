#!/bin/bash

FIFO=$(mktemp -u)
mkfifo $FIFO
(cat $FIFO | zenity --progress --pulsate --auto-close) &

response=$(process)

echo 'Bye bye' >$FIFO
rm -f $FIFO

exit

#!----------------------------------------------------------------------------------------------------
clear

#read -p "Duraçao do ping (valor em segundos): " time_ping
time_ping=2
ping -4 www.tre-pb.jus.br | grep -oP ".*time=\K\d+" | ttyplot -t "ping to 8.8.8.8"

exit

function get_decodedSelectedItems() {
   #escolhar='1 - Uso de cpu\n22 - Uso de memoria\n30 - LateNcia\n4 - Up e Down da Rede'
   selectedItems=$(echo -e "${1}") #Recebe unico parametro
   #'Funcao deve receber como argumento a saida de dialog()'
   RETVAL=''
   while IFS=$' \n' read -r items || [ -n "$items" ]; do
      if [ -n "${items}" ]; then
         RETVAL+="-${items%% *} "
      fi
   done <<<"${selectedItems}"
   echo "${RETVAL[@]}"
   exit
}

#TESTES
#selectedItems='
#1 - Uso de cpu
#2 - Uso de memoria
#3 - Latência
#4 - Up e Down da Rede'
#out=$(get_decodedSelectedItems "${selectedItems}")
#echo "${out}"
#var='-1 -3 -4'
