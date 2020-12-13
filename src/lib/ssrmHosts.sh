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
    #todo rotina as ForceDirectories ajudaria
    hpath=$(ssrmHostsGetBasePath)
    if [ ! -d "$hpath" ]; then
        mkdir "$hpath"
        if [ ! $? ]; then
            echo "Falha inicializando repositório para os hosts em ${hpath}"
            exit 1
        fi
    fi
}

#Edita os dados de um host isoladamente
function ssrmHostsEditHost() {
    host_profile="${1}"
    host_ip="${2}"
    host_enab="${3}"
    invokeEditHostData "${host_profile}" "${host_ip}" "${host_enab}"
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
        oldPath=$(ssrmHostsLocate "${host_profile}") #todo Fazer a busca por outro com os mesmos dados
        if [ -n "$oldPath" ]; then
            #todo mensagem de duplicidade de profile
            invokeMsgBox "Já existe host com mesmo nome de perfil"
        else
            #Inicia o registro do novo host com os dados coletados
            ssrmHostsSaveData "${host_profile}" "${host_ip}" "${host_enab}"
            if [[ ${RETFI} == 0 ]]; then
                invokeMsgBox "Host registrado com sucesso"
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
    #todo testar retfi=0 e mostar ok

}
