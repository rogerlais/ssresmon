#!/bin/bash
#importando arquivos
#nao sei por qual razao quando uso o ./Prototipos/nome do arquivo nao esta funcionando
#menu em loop arrumar (o cancelar deste menu)
#unica funçao funcionando eh a Inserir
#para entrar na opçao inserir tem que apertar pela segunda vez

SSRM_BASEDIR="${PWD}"  #Pode ser alterado para depuração
declare -g RETFS=''
declare -g -i RETFI=0
declare -g -a RETFA=(0)
export RETFS RETFI RETFA

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
    source "${SSRM_BASEDIR}/lib/dialogEditHost.sh"
    #todo remover linhas 
    #! - remover as 2 seguintes
    # shellcheck source=/dev/null
    #source "${SSRM_BASEDIR}/lib/dialogMonitorar.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/ssrmLogs.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/ssrmHosts.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/ssrmUtils.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogSelectHost.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogMonitorHost.sh"


    ssrmLogInit "${SSRM_BASEDIR}/logs/$(date +%F).log" #um log por dia
    ssrmHostsInitModule 
    show_menu
}

function show_menu() {
    #escolhendo um opçao
    while (true); do
        unset RETFI
        invokeMainMenu >/dev/null
        case $RETFI in
        0) exit ;;
        1) #Monitorar
            ssrmHostsMonitorHost
            ;;
        2)                             #Inserir
            ssrmHostsNewHost "" "" "" #Dados nulos
            ;;
        3) #Editar
            ssrmHostsChangeHost
            ;;
        4) #Remover
            ssrmHostsRemoveHost
            ;;
        5) #Remover
            ssrmDashShow #todo implementar urgente
            ;;
        esac
    done
}

clear
main
echo "ssresmon encerrado.!"