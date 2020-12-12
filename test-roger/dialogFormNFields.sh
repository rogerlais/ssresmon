#!/bin/bash

#** https://bash.cyberciti.biz/guide/The_form_dialog_for_input

clear

# useradd1.sh - A simple profile script to display the form dialog on screen
# set field names i.e. profile variables
host_profile="inicial profile"
host_ip="inicial host"
host_enab="S"

# open fd
exec 3>&1

# Store data to $VALUES variable
VALUES=$(dialog --ok-label "Aceitar" \
    --backtitle "Dados do host" \
    --title "Adicionar Host" \
    --form "Criar novo host" \
    12 50 0 \
    "Nome(Apelido):" 1 1 "$host_profile" 1 15 22 0 \
    "Host / IP :" 2 1 "$host_ip" 2 12 30 0 \
    "Habilitado(S/N):" 3 1 "$host_enab" 3 17 1 0 \
    2>&1 1>&3)

# close fd
exec 3>&-

# display values just entered
echo "$VALUES"
