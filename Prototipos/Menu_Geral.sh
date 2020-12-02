#!/bin/bash

Menu() {
clear

echo "Bem Vindo!"
read -p "Deseja fazer a conexao SSH? [S/N]" SSH
case $SSH in
	s|S"") read -p "Digite o nome da maquina quer deseja acessa: " name
		read -p "Agora digite o endereço IP dela: " ip
		ssh -t ${name}@${ip} -p 22 ./Menu_Secundario.sh ;;
esac
echo -n "Deseja sair? [S/N] "
read SAIR
echo
case $SAIR in
	s|S"") exit ;;
	n|N"") Menu ;;
	*) echo "Opçao invalida" ;;
esac
}

Menu
