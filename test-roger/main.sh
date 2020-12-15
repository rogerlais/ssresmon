#!/bin/bash

function runRemote() {
    remoteHost=$1
    logonUser=$2
    local args script
    array=("${@:2}")
    script="${1}"
    shift

    # generate eval-safe quoted version of current argument list
    printf -v args '%q ' "${array[@]}"

    # pass that through on the command line to bash -s
    # note that $args is parsed remotely by /bin/sh, not by bash!
    ssh -t "${logonUser}"@"${remoteHost}" "bash -s -- $args" <"$script"
}

clear

runRemote "pc-linux" "user" "/media/bash-ifpb/ssresmon/test-roger/remote.sh" "roger_remoto"

ssh -t roger@192.168.1.115 "/home/roger/roger.sh"


# shellcheck disable=SC2034,SC2088,SC2140
declare -r SAMPLER_FILE="~/ssrmsampler.yml"
# shellcheck disable=SC2034,SC2088,SC2140
declare -r SAMPLER_RUNTIME="~/sampler"

hostLkp='192.168.1.115'
logonUser='roger'

#msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\"" 2>&1 )
scmd='sampler -c ssrmsampler.yml'
#scmd=$(printf -v __ %q "${cmd}")
#printf -v scmd '%q' "${scmd}"
scmd=$(echo -e "${scmd}")
#msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp} ${scmd}" 2>&1)
#ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\""
#ssh -t -i ~/id_rsa.pem roger@"${hostLkp}" \""${SAMPLER_RUNTIME} -c ${SAMPLER_FILE}\""
#ssh -t roger@192.168.1.115 "sampler -c ssrmsampler.yml"
#!scmd="\"${scmd}\""
echo "${scmd}"
echo -e "${scmd}"
# shellcheck disable=SC2034,SC2088,SC2140
fullCmd="out=\$("ssh" -t ${logonUser}@${hostLkp} \"${scmd}\" 2>&1)"
fullCmd=$(echo -e "${fullCmd}")
eval "${fullCmd}"

ssh -t roger@192.168.1.115 "${scmd}"
scmd=$(echo -e "${scmd}")
ssh -t roger@192.168.1.115 "${scmd}"
# shellcheck disable=SC2034,SC2088,SC2140
retcode=$?
# shellcheck disable=SC2034,SC2088,SC2140
msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp} \"echo ${PWD}\"" 2>&1)
