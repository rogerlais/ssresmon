#!/bin/bash

#Falta destinar o nome+IP e profile para sua devida pasta

function get_newHostData() {
    RETVAL=$(dialog --stdout --title "Inserir Host" \
        --menu "Informe uma opçao:" 0 0 0 \
        1 'Adicionar')

    if ! $?; then
        RETVAL='0' #!atenção para possivel stress por não ter linha(s)
    else
        name_IP=$(dialog --stdout --inputbox 'Digite o nome e o IP da maquina:' 0 0)
        profile=$(dialog --stdout --inputbox 'Digite o apelido da maquina:' 0 0)
        RETVAL="1\n$name_IP\n$profile"
    fi

    echo -e "${RETVAL}"  #*Importante expandir as linhas antes

}
