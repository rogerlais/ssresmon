#!/bin/bash

echo '{
módulo contendo rottinas para tratamento de hosts da aplicação
}' >/dev/null

#dados forcados
if ${DBG_ENV}; then
    #!Ajuste de depuracao! erro se linha não nula não for inserida abaixo
    echo "debug mode!" >/dev/null
fi



function ssrmGetHostsPath () {
    echo "${SSRM_BASEDIR}/hosts"        
}


#Recebe o caminho pra o repositório dos dados dos hosts
function ssrmInitHosts() {
    if [ ! -d "$ssrmGetHostsPath" ]; then
        mkdir "$ssrmGetHostsPath"
    fi
    
            
}


#Espera receber os dados para a criação de novo host na base de dados
#Argumentos:
# 1 - Apelido
# 2 - Nome/IP
# 3 - habilitado para coleta ou não(opcional)
function ssrm_Newhost(){
    profile="${1}"
    hostname="${2}"
    enabled="${3}"


}