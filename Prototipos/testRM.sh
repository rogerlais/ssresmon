#!/bin/bash
#automatizar para fica varendo sozinho todavez que criar arquivos .txt

function Remove() {

    walk=${HOME}
    cd ${walk}/ssresmon/src/hosts
    rm .txt
}
Remove