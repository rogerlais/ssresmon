#!/bin/bash

function yadMsgBox() {  
    yad --image="${SSRM_BASEDIR}/ifpb.png" --title "Alerta" --mouse --button=gtk-ok:0 --text "${1}"
}

function invokeMsgBox() {
    yadMsgBox "${1}" "${2}" "${3}"
}
