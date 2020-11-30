#!/bin/bash

Menu() {
clear
echo " Escolha uma maquina:"
echo " 1.Maquina-1"
echo " 2.Maquina-2"
echo " 3.Maquina-3"
echo
echo -n "Esolha uma opção: "
read OPTION
echo
case $OPTION in
    1) echo "Você escolheu a opção 1" 
	    ssh -t samir@192.168.1.7 -p 22 ./Teste_Menu_Parte-1.sh;;
    2) echo "Você escolheu a opção 2" ;;
    3) echo "Você escolheu a opção 3" ;;
    *) echo "Opção inválida" ;;
esac

echo
echo -n "Sair? [S/N] "
read SAIR
echo
case $SAIR in
    s|S|"") exit ;;
    n|N|"") Menu ;;
    *) echo "Opção inválida" ;;
esac
}

Menu
