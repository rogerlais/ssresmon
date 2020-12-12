#!/bin/bash
#Falta destinar o nome+IP e profile para sua devida pasta
function get_Inserir() {
    RETVAL=$(dialog --stdout --title "Inserir Host" \
        --menu "Informe uma opçao:" 0 0 0 \
        1 'Adicionar')

    if [ $? != 0 ]; then
        RETVAL=0
    else
        RETVAL=1
        name_IP=$(dialog --stdout --inputbox 'Digite o nome e o IP da maquina:' 0 0)
        profile=$(dialog --stdout --inputbox 'Digite o apelido da maquina:' 0 0) 

    fi
    echo ${RETVAL}

}
