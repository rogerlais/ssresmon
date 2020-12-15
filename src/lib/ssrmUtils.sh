#!/bin/bash

# shellcheck disable=SC2034
declare -g RETFD=''

#Recebe string com separadores "|" e retorna arrays de elementos
function getParsedValues() {
    # shellcheck disable=SC2153
    IFS=$'\n|' read -r -a RETFA <<<"${RETFS}" #Ignorar este alerta
    #IFS=$'| \n' read -r -a RETFA <<<"${1}" #pega os items p array
    #declare -p RETFA
    #return "${RETFA[@]}"
}

function forceDirectory() {
    #Força a criação de todos os pais até o diretório solicitado
    if [ -d "$1" ]; then
        return 0
    else
        parentdir="$(dirname "${1}}")"
        if [ -d "$parentdir" ]; then
            mkdir "${1}"
            return $?
        else
            forceDirectory "${parentdir}"
        fi
    fi
}

function runRemote() {
  remoteHost=$1
  logonUser=$2
  local args script
  array=("${$@:2}")
  script="${1}"
  shift

  # generate eval-safe quoted version of current argument list
  printf -v args '%q ' "${array[@]}"

  # pass that through on the command line to bash -s
  # note that $args is parsed remotely by /bin/sh, not by bash!
  ssh -t "${logonUser}"@"${remoteHost}" "bash -s -- $args" <"$script"
}
