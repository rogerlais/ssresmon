#!/bin/bash


# shellcheck disable=SC2034 
declare -g RETFD=''

#Recebe string com separadores "|" e retorna arrays de elementos
function getParsedValues() {
    # shellcheck disable=SC2153 
    IFS=$'\n|' read -r -a RETFA  <<<"${RETFS}"  #Ignorar este alerta
    #IFS=$'| \n' read -r -a RETFA <<<"${1}" #pega os items p array
    #declare -p RETFA
    #return "${RETFA[@]}"
}