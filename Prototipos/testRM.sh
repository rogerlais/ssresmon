#!/bin/bash
#automatizar para fica varendo sozinho todavez que criar arquivos .txt

function Remove() {
    while (true); do
        cd ${HOME}/ssresmon/src/hosts
        rm .txt
    done
}
Remove
