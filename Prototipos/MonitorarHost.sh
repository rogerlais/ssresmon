#!/bin/bash

while (true); do

        escolha=$(dialog --stdout \
                --title 'Monitorador de Hosts' \
                --menu "Escolha sua opçao:" \
                0 0 0 \
                1 'Maquina-1' \
                2 'Maquina-2' \
                3 'adc...' \
                4 'adc...')
        
        if [ $? != 0 ]; then
                exit 0
        fi

        case ${escolha} in
        1) ;;
        2) ;;
        3) ;;
        4) ;;

        esac
done
