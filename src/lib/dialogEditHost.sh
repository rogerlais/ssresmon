#!/bin/bash

function yadEditHostData() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"

    if [ -z "${host_profile}" ] && [ -z "${host_ip}" ]; then
        initial_enabled='TRUE'
        initial_title='Dados do novo host'
    else
        initial_title="Editando os dados para [ ${1} ]"
        if [ "${host_enab}" ]; then
            initial_enabled='TRUE'
        else
            initial_enabled='FALSE'
        fi
    fi
    ret=$(
        yad --width=400 --mouse --title="${initial_title}" \
            --text="Por favor informe os seguintes detalhes:" --image="${SSRM_BASEDIR}/ifpb.png" \
            --form --field="Perfil(nome curto)" "${host_profile}" \
            --field="Nome host/ip" "${host_ip}" \
            --field="Habilitado(S/N):CHK" "${initial_enabled}"
        # \ "" "" "alguma coisa!!" 'Sim!Não'
    )

    retcode=${?}
    case "$retcode" in
    0)
        #trocar pipe por lago melhor no retorno
        RETFS=$(echo -e "${ret}")
        ;;
        #*Importante expandir as linhas antes
    1 | 252) #fechou janela sem confirmar
        # shellcheck disable=SC2034
        RETFS=''
        return $retcode
        ;;
    *)
        #!atenção para possivel stress por não ter linha(s)
        msg="Valor de retorno #${retcode} foi inexperado em get_newHostData()"
        ssrmLog "${msg}" #todo SAMIR pipe com tee para desduplicar
        echo "${msg}" | tee
        exit 0
        ;;
    esac
}

function invokeEditHostData() {
    yadEditHostData "${1}" "${2}" "${3}"
}
