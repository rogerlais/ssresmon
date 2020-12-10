#!/bin/bash

dialog --infobox " Bem Vindo ao Gerenciador de Recursos " 3 45
read

while (true); do

	escolha=$(dialog --stdout \
		--menu "Escolha sua opçao:" \
		0 0 0 \
		1 'Monitorar Hosts' \
		2 'Inserir Hosts' \
		3 'Editar Hosts' \
		4 'Remover Hosts' \
		5 'Dashboard' \
		6 'Configurar Exibiçao')

	if [ $? != 0 ]; then
		exit 0
	fi

	case ${escolha} in
	1) ./MonitorarHost.sh ;;
	2) ./InserirHost.sh ;;
	3) ./EditarHost.sh ;;
	4) ./RemoverHost.sh ;;
	5) ./Dashboard.sh ;;
	6) ./ConfigurarExibiçao.sh ;;
	esac
done
