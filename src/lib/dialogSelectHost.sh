#!/bin/bash

function yadSelectHost() {
    lineCount=1
    str=$(echo -e "${1}") #"deescapeia"
    items=''
    while IFS=$'|' read -r profile hostname || [ -n "$profile" ]; do
        #items+="${lineCount} \"${profile}\" \"${hostname}\" \\ \n"
        items+=" ${lineCount} \"${profile}\" \"${hostname}\" "
        ((lineCount++))
    done <<<"${str}"
    cmdLine="yad --list --image=\"${SSRM_BASEDIR}/ifpb.png\" --title=\"Lista de hosts\" --mouse --column=\"##\" --column=\"Profile\" --column=\"Hostname/IP\" --width=700 --height=250 ${items}"
    ret=$(eval "${cmdLine}")
    retcode=${?}
    case "$retcode" in
    0) #Escolha efetivada
        #:done: trocar o campo 1(ordinal) pelo 2(profile) para enviar o retorno
        RETFS="$(cut -d '|' -f 2 <<<"$ret")" #**para yad "|"" separa retorno. Pegar o campo desejado
        return 0
        ;;
    1) #cancelado
        RETFS=''
        return ${retcode}
        ;;
    252|255) #indica que aplicação será encerrada, pois foi cancelado pelo usuario
        # shellcheck disable=2034
        RETFS=''
        return ${retcode}
        ;;
    *)
        msg="Valor de retorno #${?} foi inexperado em invokeMainMenu()"
        echo "${msg}" | tee | ssrmLog "${msg}" #todo SAMIR - era deste jeito que deveria ficar!!! por o tee como antes sem sentido
        exit ${?}
        ;;
    esac
}

function invokeSelectHost() {
    yadSelectHost "${1}"
}
