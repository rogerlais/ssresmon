#!/bin/bash

runRemote() {
  local args script

  script=$1; shift

  # generate eval-safe quoted version of current argument list
  printf -v args '%q ' "$@"

  # pass that through on the command line to bash -s
  # note that $args is parsed remotely by /bin/sh, not by bash!
  ssh -t roger@192.168.1.115 "bash -s -- $args" < "$script"
}


clear

ssh -t roger@192.168.1.115  "/home/roger/roger.sh"

exit

runRemote '/media/bash-ifpb/ssresmon/test-roger/remote.sh' 'roger_remoto'

exit 1



declare -r SAMPLER_FILE="~/ssrmsampler.yml"
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
fullCmd="out=\$("ssh" -t ${logonUser}@${hostLkp} \"${scmd}\" 2>&1)"
fullCmd=$(echo -e "${fullCmd}")
eval "${fullCmd}"

ssh -t roger@192.168.1.115 "${scmd}"
scmd=$(echo -e "${scmd}")
ssh -t roger@192.168.1.115 "${scmd}"
retcode=$?
msgDetail=$(ssh -t -i ~/id_rsa.pem roger@"${hostLkp} \"echo ${PWD}\"" 2>&1)