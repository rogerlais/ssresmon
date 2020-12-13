#!/bin/bash

function yadEditHostData() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"
    #TODO para o caso de todos os argumentos serem nulos - alterar titulo para novo registro de host

    if [ -z "${host_profile}" ] && [ -z "${host_ip}" ] ; then
         initial_enabled='TRUE'
    else
        if [ "${host_enab}" ]; then
             initial_enabled='TRUE'
        else
             initial_enabled='FALSE'
        fi        
    fi
    ret=$(
        yad --width=400 --mouse --title="Dados do host" \
            --text="Por favor informe os seguintes detalhes:" --image="${SSRM_BASEDIR}/ifpb.png" \
            --form --field="Perfil(nome curto)" "perfil" \
            --field="Nome host/ip" "0.0.0.0" \
            --field="Habilitado(S/N):CHK" "${initial_enabled}" 
            # \ "" "" "alguma coisa!!" 'Sim!Não'
    )

    retcode=${?}
    case "$retcode" in
    0)
        #trocar pipe por lago melhor no retorno
        RETFS=$( echo -e "${ret}" )
        ;;
        #*Importante expandir as linhas antes
    252) #fechou janela sem confirmar
        # shellcheck disable=SC2034 
        RETFS=''
        ;;
    *)
        #!atenção para possivel stress por não ter linha(s)
        echo "Valor de retorno #{?} foi inexperado em get_newHostData()"
        exit 0
        ;;
    esac

}

function invokeEditHostData() {
    yadEditHostData "${1}" "${2}" "${3}"
}
