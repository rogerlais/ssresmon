#!/bin/bash

clear

list='servidor web1|0.0.0.1\nservidor web2|0.0.0.2\nservidor web3|0.0.0.3\nservidor web4|0.0.0.4\nservidor web5|0.0.0.5\nservidor web6|0.0.0.6\n'
lineCount=1
str=$( echo -e "${list}" )
echo "${str}"
result=''
while IFS=$'|' read -r profile hostname || [ -n "$profile" ]; do
    result+="${lineCount} \"${profile}\" \"${hostname}\" \\ \n"
    ((lineCount++))
done <<<"${str}"
result="${result::-4}" #\n\b e \\ a serem removidos
echo -e "${result}"

exit


RETFS='perfil|0.0.0.0|TRUE|'

fname='/media/bash-ifpb/ssresmon/src/hosts/perfil.txt'

#txt=$( cat "${fname}" )
#IFS=$'\n '
#txt=$( tr "\n" "\t" < "${fname}" )
#IFS=$'\t' read -r profile host_ip host_enab <<<"${txt}"

IFS=$'\n' read -r -d '\n' profile host_ip host_enab _ <"${fname}"

echo "prof- ${profile} host- ${host_ip} enab-${host_enab}"

#cat "${fname}" | read -r profile host_ip host_enab

echo "${profile} ${host_ip} ${host_enab}"

#3
IFS=$'\n|' read -r a b c d e f <<<"${RETFS}"
printf "%s-%s-%s-%s-%s-%s" "${a}" "${b}" "${c}" "${d}" "${e}" "${f}"

IFS=$'\n|' read -r -a TA <<<"${RETFS}"
echo "tamanho = ${#TA}"
echo "tamanho = ${#TA[@]}"
for item in "${TA[@]}"; do
    printf "%s - " "${item}"
done
