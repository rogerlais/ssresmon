#!/bin/bash

function yadMainMenu() {
	#ssrmLog "--image=\"${SSRM_BASEDIR}/ifpb_3.png\"" não resolveu, mantendo ---image="gtk-execute" 

	#todo tentar trocar imagem do menu
	ret=$(
		yad --list --width=660 --height=250  \
			--image="${SSRM_BASEDIR}/ifpb.png"  \
			--title="Menu Principal" --mouse --column="#" --column="Opção" --column="Descrição" \
			1 "Monitorar host" "Visualizar um host específico" \
			2 "Inserir host" "Registrar um novo host p/ operação" \
			3 "Editar host" "Alterar dados de host existente" \
			4 "Remover host" "Remover entrada de host existente" \
			5 "Dashboard" "Exibe dashboard(parcial)" 
			)
	retcode=${?}
	case "$retcode" in
	0)                                    #Escolha efetivada
		RETFI="$(cut -d '|' -f 1 <<<"$ret")" #**para yad | separa retorno. Pegar o primeiro
		;;
	1) #cancelado
		RETFI=0 ;;
	255) #indica que aplicação será encerrada, pois foi cancelado pelo usuario
		RETFI=0 ;;
	*)
		echo "Valor de retorno #{?} foi inexperado em invokeMainMenu()" | tee
		exit 0
		;;
	esac

}

function show_MainMenu() {
	clear
	clear >"$(tty)"
	# open fd
	exec 3>&1
	RETFI=$(dialog --stdout --title "Menu Principal" \
		--menu "Informe uma opçao:" \
		0 0 0 \
		1 'Monitorar Hosts' \
		2 'Inserir Hosts' \
		3 'Editar Hosts' \
		4 'Remover Hosts')
	#\
	#2>&1 1>&3
	retcode=${?}
	#close fd
	exec 3>&-

	case "$retcode" in
	0) #Escolha efetivada
		echo "${RETFI}" >$VERBOUT
		;;
	255) #indica que aplicação será encerrada, pois foi cancelado pelo usuario
		echo "0" ;;
	*)
		echo "Valor de retorno #{?} foi inexperado em invokeMainMenu()" | tee
		exit 0
		;;
	esac
}

function invokeMainMenu() {
	yadMainMenu
}

#ret=$(invokeMainMenu)
#echo -e "retorno: ${ret}"
