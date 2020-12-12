#!/bin/bash

echo '{
módulo com as rotinas de logo globais
}' >/dev/null

function ssrmInitLog() {
    parentdir="$(dirname "${1}}")"
    if [ ! -d "$parentdir" ]; then
        mkdir "$parentdir"
    fi    
    if [ ! -f "${1}" ]; then
        touch "${1}"
    fi
    if [ -w "${1}" ]; then
        SSRM_LOG_FILE="${1}"
    else
        echo "ARQUIVO DE LOG NÃO PODE SER ACESSADO EM: ${1}"
    fi
}

function ssrmLog() {
    echo -e "${1}" >>"$SSRM_LOG_FILE"
}
