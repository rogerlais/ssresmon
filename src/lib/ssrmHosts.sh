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
function ssrmGetHostsPath() {
    echo "${SSRM_BASEDIR}/hosts"
}

#Recebe o caminho pra o repositório dos dados dos hosts e faz sua verificação/inicialização
function ssrmInitHosts() {
    hpath=$(ssrmGetHostsPath)
    if [ ! -d "$hpath" ]; then
        mkdir "$hpath"
        if [ ! $? ]; then
            echo "Falha inicializando repositório para os hosts em ${hpath}"
            exit 1
        fi
    fi
    #!pergunta - necessário para cada módulo importar o outro ou é global????
    # shellcheck source=/dev/null
    source "${SSRM_BASEDIR}/dialogInsertHost.sh"
}

#Edita os dados de um host isoladamente
function register_HostData () {
    host_profile="{$1}"
    host_ip="{$2}"
    host_enab="{$3}"
    hostData=$(edit_HostData "${host_profile}" "${host_ip}" "${host_enab}")
    #Faz a busca por outro com os mesmos dados
}


#Varre repositório, abrindo cada arquivo a procura da assinatuta do profile desejado
function ssrmLocateHost() {
    if [ -n "${1}" ]; then
        hpath=$(ssrmGetHostsPath)
        for name in "$hpath"/*.txt; do
            dataFile="${name}"
            hostData=$(ssrmGetHostData "${dataFile}")
            if [ hostData[0] == "${1}" ]; then
                RETVAL=${hostData}
                return
            fi
        done
    fi

}

#Espera receber os dados para a criação de novo host na base de dados
#Argumentos:
# 1 - Apelido
# 2 - Nome/IP
# 3 - habilitado para coleta ou não(opcional)
function ssrm_Newhost() {
    profile="${1}"
    hostname="${2}"
    enabled="${3}"

}
