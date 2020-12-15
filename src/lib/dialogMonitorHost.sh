#!/bin/bash

# shellcheck source=/dev/null
source "${SSRM_BASEDIR}/lib/ssrmUtils.sh"
# shellcheck source=/dev/null
source "${SSRM_BASEDIR}/lib/dialogInfo.sh"

#* vars protegidas
#declare -r SAMPLER_FILE="~/ssrmsampler.yml"
declare -r REMOTE_COMMAND="/usr/local/bin/remote.sh"
declare -r LOGON_USER="roger"  #!Devido a mudança do projeto que sai do SNMP para ssh, tal parametro não existia

#Faz conexão com o host remoto via ssh e mostra sampler
function invokeMonitoreHost() {
    ssrmHostsReadData "${1}"
    retcode=${?}
    if ! ((retcode)); then
        retArray=("${RETFA[@]}")
        hostLkp="${retArray[1]}" #Coleta o endereço do host - ordinal 1 do vetor
    else
        msg="Não foi possível ler os dados para o host \"${1}\" - erro(\"${retcode}\")"
        ssrmLog "${msg}"
        invokeMsgBox "${msg}"
        return $retcode
    fi
    if [ -n "$hostLkp" ]; then
        #ssh -t roger@192.168.1.115 "sampler -c ssrmsampler.yml" ! esta foi a STA para a entrega, ou seja chamada crua e nua 
        #msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\"" 2>&1 )
        msgDetail="Parabéns ao par BASHxSSH!"  #!Não encontrada solução para captura do erro remoto em todos os níveis
        #ssh -t "${LOGON_USER}@${hostLkp}" "${REMOTE_COMMAND}"
        ssh -t "${LOGON_USER}@${hostLkp}" "${REMOTE_COMMAND}"
        retcode=$?
        clear
        if ! ((retcode)); then
            msg="Monitoramento ao host \"${1}\" endereçado por: \"${hostLkp}\" finalizado com sucesso."
            ssrmLog "${msg}"
            invokeMsgBox "${msg}"
        else
            #Testar arquivos via funções
            msg="Falha durante acesso SSH ao host \"(${1})\"\nEndereço:${hostLkp}\nCódigo de erro: ${retcode} \nDetalhes:\n${msgDetail}"
            ssrmLog "${msg}"
            invokeMsgBox "${msg}"
        fi
    else
        invokeMsgBox "Dados para \"${1}\" não encontrados ou inválidos"
    fi
}
