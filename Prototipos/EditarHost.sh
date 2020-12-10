#!/bin/bash

while (true); do

       escolha=$( dialog --stdout \
        --title 'Editar Hosts' \
        --checklist 'Escolha as opçoes desejadas:' 0 0 0 \
        "Uso de cpu" '' ON  \
        "Uso de memoria" '' OFF \
        "Latencia" '' ON  \
        "Up e Down da Rede" '' OFF )


        if [ $? != 0 ]; then
                exit 0
        fi

        


done


