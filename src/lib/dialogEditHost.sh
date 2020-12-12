#!/bin/bash

function yadHostData() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"
    #todo para o caso de todos os argumentos serem nulos - alterar titulo para novo registro de host

    ret=$(
        yad --width=400 --mouse --title="Dados do host" \
            --text="Por favor informe os seguintes detalhes:" --image="${SSRM_BASEDIR}/ifpb.png" --size="48px" \
            --form --field="Perfil(nome curto)" "perfil" \
            --field="Nome host/ip" "0.0.0.0" \
            --field="Habilitado(S/N):CHK" 
            # \ "" "" "alguma coisa!!" 'Sim!Não'
    )

    retcode=${?}
    case "$retcode" in
    0)
        #trocar pipe por lago melhor no retorno
        RETFS=$( echo -e ${ret} )
        export RETFS
        ;;
        #*Importante expandir as linhas antes
    252) #fechou janela sem confirmar
        RETFS=''
        ;;
    *)
        #!atenção para possivel stress por não ter linha(s)
        echo "Valor de retorno #{?} foi inexperado em get_newHostData()"
        exit 0
        ;;
    esac

}

function dialogHostData() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"

    clear
    clear >"$(tty)"
    # open fd
    exec 3>&1
    # Store data to $VALUES variable
    RETFA=$(dialog --ok-label "Aceitar" \
        --backtitle "Dados do host" \
        --title "Adicionar Host" \
        --form "Criar novo host" \
        12 50 0 \
        "Nome(Apelido):" 1 1 "$host_profile" 1 15 22 0 \
        "Host / IP :" 2 1 "$host_ip" 2 12 30 0 \
        "Habilitado(S/N):" 3 1 "$host_enab" 3 17 1 0)
    retcode=${?}
    # close fd
    exec 3>&-

    # display values just entered
    #!echo "$RETVAL"

    case "$retcode" in
    0)
        RETFS=''
        for item in ${RETFA}; do
            RETFS+="${item}\n"
        done
        echo -e "${RETFS}"
        ;;
        #*Importante expandir as linhas antes
    2 | 3)
        echo "case 2 or 3"
        ;;
    *)
        #!atenção para possivel stress por não ter linha(s)
        echo "Valor de retorno #{?} foi inexperado em get_newHostData()"
        exit 0
        ;;
    esac
}

function edit_HostData() {
    #host_profile="${1}"
    #host_ip="${2}"
    #host_enab="${3}"
    ret=$(yadHostData "${1}" "${2}" "${3}")
}
