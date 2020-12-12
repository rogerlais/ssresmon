#!/bin/bash
#importando arquivos
#nao sei por qual razao quando uso o ./Prototipos/nome do arquivo nao esta funcionando
#menu em loop arrumar (o cancelar deste menu)
#unica funçao funcionando eh a Inserir
#para entrar na opçao inserir tem que apertar pela segunda vez

source ./dialogMenu.sh
source ./dialogInserir.sh
source ./dialogMonitorar.sh
source ./dialogEditarHost.sh
source ./dialogRemover.sh


#escolhendo um opçao
while (true); do
    men=$(get_Menu)
    case ${men} in
    0) exit ;;
    1) #Monitorar
        mon=$(get_Monitora)

        ;;
    2) #Inserir
        ins=$(get_Inserir)

        ;;
    3) #Editar
        edit=
        ;;
    4) #Remover
        rem=$(get_Remove)
        ;;
    esac
done
