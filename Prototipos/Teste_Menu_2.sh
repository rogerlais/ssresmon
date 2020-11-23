#!/bin/bash
#Fazer as alteraçoes necessarias, caso seja escolhido, configuro as opçoes
Menu() {
clear
echo " Opções:"
echo " 1."
echo " 2."
echo " 3."
echo " A."
echo " B."
echo " C."
echo
echo -n "Esolha uma opção: "
read OPTION
echo
case $OPTION in
    1) echo "Você escolheu a opção 1" ;;
    2) echo "Você escolheu a opção 2" ;;
    3) echo "Você escolheu a opção 3" ;;
    a|A|"") echo "Você escolheu a opção A" ;;
    b|B|"") echo "Você escolheu a opção B" ;;
    c|C|"") echo "Você escolheu a opção C" ;;
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
