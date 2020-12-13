#!/bin/bash

clear

RETFS='perfil|0.0.0.0|TRUE|'

#3
IFS=$'\n|' read -r a b c d e f <<<"${RETFS}"
printf "%s-%s-%s-%s-%s-%s" "${a}" "${b}" "${c}" "${d}" "${e}" "${f}"

IFS=$'\n|' read -r -a TA <<<"${RETFS}"
echo "tamanho = ${#TA}"
echo "tamanho = ${#TA[@]}"
for item in "${TA[@]}"; do
    printf "%s - " "${item}"
done

#2
res=${RETFS//|/ }
echo "$res"
printf "%s\n" "${res}"
echo "${#res}"
printArray "${res[@]}"

#1
res="${RETFS//[^|]/}"
echo "$res"
printf "%s\n" "${res}"
echo "${#res}"
printArray "${res[@]}"
