#!/bin/bash
#importando arquivos
#nao sei por qual razao quando uso o ./Prototipos/nome do arquivo nao esta funcionando
#menu em loop arrumar (o cancelar deste menu)
#unica funçao funcionando eh a Inserir
#para entrar na opçao inserir tem que apertar pela segunda vez

function main() {
    if [[ ${DBG^^} == "'YES'" ]]; then #depurador avalia '[[ 'YES' == YES ]]' como verdadeiro
        DBG_ENV=true
    else
        DBG_ENV=false
    fi
    export DBG_ENV

    if ${DBG_ENV}; then
        #!Ajuste de depuracao! erro se linha não nula não for inserida abaixo
        echo "debug!" >/dev/null
        BASEDIR="${PWD}/Prototipos"
    else
        BASEDIR="${PWD}/Prototipos"
    fi
    # shellcheck source=/dev/null
    source "${BASEDIR}/dialogMenu.sh"
    # shellcheck source=/dev/null
    source "${BASEDIR}/dialogInserir.sh"
    # shellcheck source=/dev/null
    source "${BASEDIR}/dialogMonitorar.sh"
    # shellcheck source=/dev/null
    source "${BASEDIR}/dialogEditarHost.sh"
    # shellcheck source=/dev/null
    source "${BASEDIR}/dialogRemover.sh"
    show_menu
}

function show_menu() {
    #escolhendo um opçao
    while (true); do
        men=$(get_Menu)
        case ${men} in
        0) exit ;;
        1) #Monitorar
            mon=$(get_Monitora)
            ;;
        2) #Inserir
            ins=$(get_Inserir)
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

main
