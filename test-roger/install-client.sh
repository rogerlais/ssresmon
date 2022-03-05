#!/bin/bash

#Globais
SNMPD_CONF_FILE='/etc/snmp/snmpd.conf'

function main() {
    if [[ ${DBG^^} == "'YES'" ]]; then #depurador avalia '[[ 'YES' == YES ]]' como verdadeiro
        DBG_ENV=true
    else
        DBG_ENV=false
    fi
    export DBG_ENV

    if ${DBG_ENV}; then
        #!Ajuste de depuracao! erro se linha não nula não for inserida abaixo
        echo "debug!" >$VERBOUT
        confSvcFile="${PWD}/test-roger/snmpd.conf.original"
    else
        confSvcFile="${SNMPD_CONF_FILE}"
    fi
    #* caso primeira linha difere de #!/bin/bash -> erro
    [ ${EUID} -eq 0 ] && isRoot=true || isRoot=false
    if [ ${isRoot} == false ]; then #pense numa leseira essas comparações
        echo "Please run as root"
        exit
    fi
    LOGFILE='./install-client.log'
    #!installsnmpd
    updateSNMPConf "${confSvcFile}"
}

function installsnmpd() {
    #todo verificar se existia antes
    echo "Instalando pacotes necessários ao serviço SNMP..."
    if [[ $(apt-get install snmpd* -y 2>>"${LOGFILE}") ]]; then
        echo "SNMPD instalado com sucesso"
    else
        echo "Falha instalando SNMP"
        return
    fi
    echo "Instalando MIBS-Downloader..."
    if [[ $(apt-get install snmp-mibs-downloader -y 2>>"${LOGFILE}") ]]; then
        echo "MIBS instalado com sucesso"
    else
        echo "Falha instalando SNMP"
        return
    fi

    #! boas fontes dos requisitos em:
    #https://serverfault.com/questions/333692/snmp-access-on-ubuntu
    #https://help.ubuntu.com/community/SNMPAgent

    #libera firewall 161 e 162(esta ultima nao sei razao)
    echo "Liberando portas de acesso ao serviço..."
    if [[ $(ufw allow 161:162/udp 2>>"${LOGFILE}") ]]; then
        echo "Portas 161 e 162 UDP liberadas com sucesso"
    else
        echo "Falha instalando SNMP"
        return
    fi
    echo "Instalação do serviço/agente SNMP concluída!!!"
}

function updateSNMPConf() {
    suffix=$(date +%F_%H%M)
    cp "${1}" "${1}.${suffix}"
    workfile="${1%.*}.tmp"
    cp "${1}" "${workfile}"
    #todos endereços para bind
    #sed -E "s// **CENSURADO**/g" "${dataFile}" > "${outFile}"
    sed -E 's/^agentAddress[.]*/agentAddress   udp:161/g' "${1}" 
    read -r -p "pause..." | /dev/null

    #agentAddress 127.0.0.0:???   -> agentAddress  udp:161  #trocar a linha diretamente
    #rocommunity public  default    -V systemonly  -> rocommunity public 172.16.0.0/20 ou rocommunity public 0.0.0.0/0

}

#echo "createuser shell2020 SHA-512 simetrico AES assimetrico" >/var/lib/snmp/snmpd.conf

clear
main
