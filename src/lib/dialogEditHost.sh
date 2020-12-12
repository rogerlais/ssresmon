#!/bin/bash

#Falta destinar o nome+IP e profile para sua devida pasta

function edit_HostData() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"

    clear
    # open fd
    exec 3>&1
    # Store data to $VALUES variable
    RETVAL=$(dialog --ok-label "Aceitar" \
        --backtitle "Dados do host" \
        --title "Adicionar Host" \
        --form "Criar novo host" \
        12 50 0 \
        "Nome(Apelido):" 1 1 "$host_profile" 1 15 22 0 \
        "Host / IP :" 2 1 "$host_ip" 2 12 30 0 \
        "Habilitado(S/N):" 3 1 "$host_enab" 3 17 1 0 \
        2>&1 1>&3)
    retcode=${?}
    # close fd
    exec 3>&-

    # display values just entered
    #!echo "$RETVAL"

    case "$retcode" in
    0)
        echo -e "${RETVAL}"
        ;;
        #*Importante expandir as linhas antes
    2 | 3)
        echo "case 2 or 3"
        ;;
    *)
        RETVAL='0'
        #!atenção para possivel stress por não ter linha(s)
        echo "Valor de retorno #{?} foi inexperado em get_newHostData()"
        exit 0
        ;;
    esac

}
