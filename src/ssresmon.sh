#!/bin/bash
#importando arquivos
#nao sei por qual razao quando uso o ./Prototipos/nome do arquivo nao esta funcionando
#menu em loop arrumar (o cancelar deste menu)
#unica funçao funcionando eh a Inserir
#para entrar na opçao inserir tem que apertar pela segunda vez

SSRM_BASEDIR="${PWD}"

function main() {
    if [[ ${DBG^^} == "'YES'" ]]; then #depurador avalia '[[ 'YES' == YES ]]' como verdadeiro
        DBG_ENV=true
    else
        DBG_ENV=false
    fi
    export DBG_ENV

    if ${DBG_ENV}; then #!Ajuste de depuracao! erro se linha não nula não for inserida abaixo
        echo "debug!" >/dev/null
        SSRM_BASEDIR="${PWD}/src"
    fi
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogMenu.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogInsertHost.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogMonitorar.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogEditarHost.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogRemover.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/ssrmLogs.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/ssrmHosts.sh"

    ssrmInitLog "${SSRM_BASEDIR}/logs/$(date +%F).log" #um log por dia
    show_menu
}

function show_menu() {
    #escolhendo um opçao
    while (true); do
        mainChoice=$(get_MainMenu)
        case ${mainChoice} in
        0) exit ;;
        1) #Monitorar
            mon=$(get_Monitora)
            ;;
        2) #Inserir
            register_HostData
            ;;
        3) #Editar
            edit=nullLines
            ;;
        4) #Remover
            rem=$(get_Remove)
            ;;
        esac
    done
}

clear
main
