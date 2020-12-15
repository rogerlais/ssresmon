#!/bin/bash

# shellcheck source=/dev/null
source "${SSRM_BASEDIR}/lib/ssrmUtils.sh"
# shellcheck source=/dev/null
source "${SSRM_BASEDIR}/lib/dialogInfo.sh"

#* vars protegidas
#declare -r SAMPLER_FILE="~/ssrmsampler.yml"
#declare -r SAMPLER_RUNTIME="/usr/local/bin/sampler"

declare -r SAMPLER_FILE="~/ssrmsampler.yml"
declare -r SAMPLER_RUNTIME="~/sampler"

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
        hostLkp='192.168.1.115'
        #msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\"" 2>&1 )
        scmd='ls; read -p -r "veja a merda"'
        #scmd=$(printf -v __ %q "${cmd}")
        printf -v scmd '%q' "${scmd}"
        scmd=$(echo -e "${scmd}")
        #msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp} ${scmd}" 2>&1)

        ssh -t roger@192.168.1.115 "sampler -c ssrmsampler.yml"
        clear
        retcode=0

        #ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\""
        #ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\""
        retcode=${?}
        if ! ((retcode)); then
            ssrmLog "Monitoramento ao host ${hostLkp} finalizado com sucesso."
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
