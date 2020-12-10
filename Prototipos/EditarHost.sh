#!/bin/bash
escolha=$( dialog --stdout \
        --menu "Escolha sua opçao" \
        0 0 0 \
        1 'Uso de CPU' \
        2 'Uso de Memoria' \
        3 'Latencia' \
        4 'Up e Down da Rede' \
        5 'Voltar')

echo "O usuário escolheu: ${escolha}"


case ${escolha} in
        1) ;;
        2) ;;
        3) ;;
        4) ;;
        5) ./menudiag.sh;;
        
esac

