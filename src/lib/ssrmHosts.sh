#!/bin/bash

echo '{
módulo contendo rottinas para tratamento de hosts da aplicação

#!Os arquivos de cada host possuem a seguinte estrutura
[nnnn.dat]              #nome de arquivo com 4 digitos 
profile=<profilename>   #especie de nome curto para o host
hostip=<name|ip>        #nome ou ip do host
enabled=<0|1>           #idica se o host entra na lista de ativos monitorados no ciclo

}' >/dev/null

#dados forcados
if ${DBG_ENV}; then
    #!Ajuste de depuracao! erro se linha não nula não for inserida abaixo
    echo "debug mode!" >/dev/null
fi

#Leitra do caminho com os dados dos hosts registrados
function ssrmHostsGetBasePath() {
    echo "${SSRM_BASEDIR}/hosts"
}

function ssrmHostsSaveData() {
    hostdatafile="$(ssrmHostsGetBasePath)/${1}.txt"
    echo -e "${1}\n${2}\n${3}\n." >"${hostdatafile}"
    if [ $? ]; then
        RETFI=0
    else
        RETFI=1
    fi

}

#Recebe o caminho pra o repositório dos dados dos hosts e faz sua verificação/inicialização
function ssrmHostsInitModule() {
    #!pergunta - necessário para cada módulo importar o outro ou é global????
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogEditHost.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/ssrmUtils.sh"
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/lib/dialogInfo.sh"
    hpath=$(ssrmHostsGetBasePath)
    forceDirectory "${hpath}"
    if [ ! $? ]; then
        lastError=$?
        invokeMsgBox "Falha inicializando repositório para os hosts em ${hpath}"
        return $lastError
    fi
}

#Edita os dados de um host isoladamente
function ssrmHostsEditHost() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"
    invokeEditHostData "${host_profile}" "${host_ip}" "${host_enab}"
    # shellcheck disable=2153
    if [ -n "$RETFS" ]; then
        getParsedValues "${RETFS}"        #Carrega dados para RETFA
        retArray+=("${RETFA[@]}")         #Recupera valor da global logo pra ser feliz
        if [ ${#retArray[@]} == 3 ]; then #Valores validos
            host_profile="${retArray[0]}"
            host_ip="${retArray[1]}"
            host_enab="${retArray[2]}"
        else
            echo "Valores passados inválidos: "
            printf '%s\n' "${retArray[@]}"
        fi
        unset retArray
        oldPath=$(ssrmHostsLocate "${host_profile}") #Faz a busca por outro com os mesmos dados
        if [ -n "$oldPath" ]; then
            invokeMsgBox "$(printf '%b' "Já existe host com mesmo nome de perfil\n(${host_profile})")"
        else
            #Inicia o registro do novo host com os dados coletados
            ssrmHostsSaveData "${host_profile}" "${host_ip}" "${host_enab}"
            if [[ ${RETFI} == 0 ]]; then
                invokeMsgBox "Host ${host_profile} salvo com sucesso"
            fi
        fi
    fi
}

#Varre repositório, abrindo cada arquivo a procura da assinatuta do profile desejado
function ssrmHostsLocate() {
    if [ -n "${1}" ]; then
        hpath=$(ssrmHostsGetBasePath)
        hmask="${hpath}/${1}.txt"
        if [ -r "$hmask" ]; then
            echo "${hmask}"
        else
            echo ''
        fi
    else
        echo ''
    fi
}

#Espera receber os dados para a criação de novo host na base de dados
#Argumentos:
# 1 - Apelido
# 2 - Nome/IP
# 3 - habilitado para coleta ou não(opcional)
function ssrmHostsNewHost() {
    profile="${1}"
    hostname="${2}"
    enabled="${3}"
    ssrmHostsEditHost "${profile}" "${hostname}" "${enabled}"
}

function ssrmHostsGetList() {
    #todo montar string com a lista dos profile(nome, hostname) onde cada linha é nome|hostname
    hpath="$(ssrmHostsGetBasePath)/*"
    result=''
    for fname in ${hpath}; do
        if [ "$hpath" != "$fname" ]; then
            IFS=$'\n' read -r -d '\n' profile host_ip host_enab _ <"${fname}" #fresca com dummy mas usa _ pqp
            item="${profile}|${host_ip}\n"
            result+=${item}
        else
            return 1 #Sem dados/lista vazia
        fi
    done
    RETFS=${result}
    return 0
}

function ssrmHostsSelect() {
    #Recebe string onde cada linha possui <profilename>|<hostname>
    inputList=${1} #lista com os hosts existentes
    invokeSelectHost "${inputList}"
    if [ $? ]; then
        echo "${RETFS}"
    else
        return $?
    fi    
}

#Seleciona host da lista
function ssrmHostsMonitorHost() {
    ssrmHostsGetList #Monta a string com a lista de hosts
    if [ $? ]; then
        hlist=${RETFS}             #Valor ainda escaped
        ssrmHostsSelect "${hlist}" #Mostra janela para escolha do hos
        if [ $? ]; then
            sel=${RETFS} #Armazena o host selecionado
            invokeMonitoreHost "${sel}"
        fi
    else
        invokeMsgBox "Não há dados de hosts cadastrados no momento"
    fi
}
