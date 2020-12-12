#!/bin/bash
#falta varrer a pasta e apagar o host

function get_Remove() {
    RETVAL=$(dialog --stdout \ 
        --title "Remover Host" \
        --menu "Informe uma opçao:" 0 0 0 \
        1 'Remover' )

    if [ $? != 0 ]; then
		RETVAL=0
    else
        RETVAL=1
        name_IP=$( dialog --stdout --inputbox 'Digite o nome e o IP da maquina que deseja remover:' 0 0)
        
    fi
    echo ${RETVAL}

    
}}