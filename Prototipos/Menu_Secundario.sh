#!/bin/bash

echo -e "Escolha uma opçao\n1-Ver uso de Memoria e CPU\n2-Testar a latencia\n3-Upload e Download da rede\n"
read -p "Digite o numero relacionado a opçao: " num

case ${num} in
	"1") htop ;;
	"2") read -p "Para onde deseja testar a latencia? " laten
		ping ${laten} ;;
	"3") ./speedtest-cli
esac

