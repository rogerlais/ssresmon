#!/bin/bash

while (true); do

        escolha=$(dialog --stdout \
                --title 'Dashboard' \
                --menu "Escolha sua opçao:" \
                0 0 0 \
                1 'adc...' \
                2 'adc...' \
                3 'adc...' \
                4 'adc...')

        if [ $? != 0 ]; then
                exit 0
        fi

        case ${escolha} in
        1) ping 8.8.8.8 | sed -u 's/^.*time=//g; s/ ms//g' | ttyplot ;;
        2) ;;
        3) ;;
        4) ;;

        esac
done
