#!/bin/bash
Menu() {
clear
read -p "Deseja abrir as configuraçoes? [S/N]" conf
case $conf in
	s|S"") echo "Escolha uma opçao\n1-Ver uso de Memoria e CPU\n2-Testar a latencia\n3-Upload e Download da rede\n"	
		"Digite o numero relacionado a opçao: " num
		case ${num} in
			"1") htop ;;
			"2") read -p "Para onde deseja testar a latencia? " laten
				ping ${laten} ;;
			"3") ./speedtest-cli
		esac
esac
echo
read -p "Dseja sair? [S/N]" sair
case $sair in
	S|s"") exit ;;
	N|n"") Menu ;;
	*) echo "opçao invalida" ;;
esac
}
Menu
