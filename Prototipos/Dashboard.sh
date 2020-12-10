#!/bin/bash

escolha=$( dialog --stdout \
        --menu "Escolha sua opçao" \
        0 0 0 \
        1 'adc...' \
        2 'adc...' \
        3 'adc...' \
        4 'adc...' \
        5 'Voltar' )

echo "O usuário escolheu: ${escolha}"


case ${escolha} in
        1) ;;
        2) ;;
        3) ;;
        4) ;;
        5) ./menudiag.sh;;
esac

