clear
cd ../ssresmon/test-roger/
source ./test1.sh
echo "${PWD}"


#Retorno equivale a TUDO selecionado
dialogReturn='  
1 - Uso de cpu
2 - Uso de memoria
3 - Latência
4 - Up e Down da Rede'

dialogReturn='4 - Up e Down da Rede'

dialogReturn=''

ret=$(get_decodedSelectedItems "${dialogReturn}" )

echo -e "${ret}"
