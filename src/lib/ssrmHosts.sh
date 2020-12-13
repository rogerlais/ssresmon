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
function __ssrmHostsGetBasePath() {
    echo "${SSRM_BASEDIR}/hosts"
}

function _ssrmHostsSaveData() {
    hostdatafile="$(__ssrmHostsGetBasePath)/${1}.txt"
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
    hpath=$(__ssrmHostsGetBasePath)
    forceDirectory "${hpath}"
    if [ ! $? ]; then
        lastError=$?
        invokeMsgBox "Falha inicializando repositório para os hosts em ${hpath}"
        return $lastError
    fi
}

#Edita os dados de um host isoladamente
function _ssrmHostsEditHost() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"
    invokeEditHostData "${host_profile}" "${host_ip}" "${host_enab}"
    if [ ! $? ]; then #Houve cancelamento ou erro
        return $?
    fi
    unset RETFA
    getParsedValues "${RETFS}"        #Carrega dados para RETFA
    retArray=("${RETFA[@]}")         #Recupera valor da global logo pra ser feliz
    if [ ${#retArray[@]} == 3 ]; then #!(3)Valor valido vai depender da quantidade de dados
        host_profile="${retArray[0]}"
        host_ip="${retArray[1]}"
        host_enab="${retArray[2]}"
    else
        msg=$( printf "%s\n%s" "Valores passados inválidos: " "${retArray[@]}" )
        invokeMsgBox "${msg}"
    fi
    unset retArray

    newPath=$(ssrmHostsLocate "${host_profile}")

    #*VALIDAÇÃO DE ANTIGO PARA NOVO!!!
    if [ -z "${1}" ]; then #novo perfil, apenas não pode ter antigo com o mesmo nome
        if [ -f "${newPath}" ]; then
            invokeMsgBox "$(printf '%b' "Já existe host com mesmo nome de perfil\n(${host_profile})")"
            return 1
        fi
    else
        oldPath=$(ssrmHostsLocate "${1}")        #Faz a busca por outro com os mesmos dados
        if [ "${1}" != "${host_profile}" ]; then #houve mudanca de nome
            if [ -f "${newPath}" ]; then
                invokeMsgBox "$(printf '%b' "Já existe host com mesmo nome de perfil\n(${host_profile})\nAlteração de ${1} não será possível!")"
                return 1
            fi
        fi
        rm "${oldPath}" #*Apaga dado anterior para nova gravação
    fi
    _ssrmHostsSaveData "${host_profile}" "${host_ip}" "${host_enab}"
    if [[ ${RETFI} == 0 ]]; then
        invokeMsgBox "Host ( \"${host_profile}\" ) foi salvo com sucesso"
    fi
}

#Varre repositório, abrindo cada arquivo a procura da assinatuta do profile desejado
function ssrmHostsLocate() {
    if [ -n "${1}" ]; then
        hpath=$(__ssrmHostsGetBasePath)
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
    _ssrmHostsEditHost "${profile}" "${hostname}" "${enabled}"
}

#string com a lista dos profile(nome, hostname) onde cada linha é nome|hostname
function __ssrmHostsGetList() {
    hpath="$(__ssrmHostsGetBasePath)/*"
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
    __ssrmHostsGetList #Monta a string com a lista de hosts
    if [ $? ]; then
        hlist=${RETFS}             #Valor ainda escaped
        ssrmHostsSelect "${hlist}" #Mostra janela para escolha do hos
        if [ $? ]; then
            sel=${RETFS} #Armazena o host selecionado
            invokeMonitoreHost "${sel}"  #todo implementar urgentemente
        fi
    else
        invokeMsgBox "Não há dados de hosts cadastrados no momento"
    fi
}

function ssrmHostsChangeHost() {
    __ssrmHostsGetList #Monta a string com a lista de hosts
    if [ $? ]; then
        hlist=${RETFS}             #Valor ainda escaped
        ssrmHostsSelect "${hlist}" #Mostra janela para escolha do hos
        if [ $? ]; then
            sel=${RETFS} #Armazena o host selecionado
            ssrmHostsReadData "${sel}"
            if [ $? ]; then
                retArray=("${RETFA[@]}")
                _ssrmHostsEditHost "${retArray[0]}" "${retArray[1]}" "${retArray[2]}"
            else
                return $?
            fi
        fi
    else
        invokeMsgBox "Não há dados de hosts cadastrados no momento"
    fi
}

#Retorna todos os dados de um host, dado o seu profile
function ssrmHostsReadData() {
    dataFile=$(ssrmHostsLocate "${1}")
    if [ -r "${dataFile}" ]; then
        IFS=$'\n' read -r -d '\n' profile host_ip host_enab _ <"${dataFile}" #fresca com dummy mas usa _ pqp
        #printf "%s" "${profile}|${host_ip}|${host_enab}\n"
        unset RETFA
        RETFA=("${profile}" "${host_ip}" "${host_enab}")
        return 0
    else
        return 1
    fi
}

function ssrmHostsRemoveHost () {
    __ssrmHostsGetList #Monta a string com a lista de hosts
    if [ $? ]; then
        hlist=${RETFS}             #Valor ainda escaped
        ssrmHostsSelect "${hlist}" #Mostra janela para escolha do hos
        if [ $? ]; then
            sel=${RETFS} #Armazena o host selecionado
            dataFile=$(ssrmHostsLocate "${sel}")
            rm "${dataFile}"
            if [ $? ]; then
                invokeMsgBox "Host (\"${sel}\") removido com sucesso."        
            fi           
        fi
    else
        invokeMsgBox "Sua lista de hosts eatá vazia no momento"
    fi    
}

