#!/bin/bash

while (true); do

       escolha=$( dialog --stdout \
                --separate-output \
                --title 'Editar Hosts' \
                --checklist 'Escolha as opçoes desejadas:' 0 0 0 \
                "Uso de cpu" '' OFF  \
                "Uso de memoria" '' OFF \
                "Latencia" '' OFF  \
                "Up e Down da Rede" '' OFF )


        echo "${escolhaescolha}" | while read LINHA
        do
                echo "--- ${LINHA}"
        done
        if [ $? != 0 ]; then
                exit 0
        fi

done

