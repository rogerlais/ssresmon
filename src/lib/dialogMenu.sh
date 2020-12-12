#!/bin/bash

function get_MainMenu() {
  clear
  # open fd
  exec 3>&1
  RETVAL=$(
    dialog --stdout --title "Menu Principal" \
      --menu "Informe uma opçao:" \
      0 0 0 \
      1 'Monitorar Hosts' \
      2 'Inserir Hosts' \
      3 'Editar Hosts' \
      4 'Remover Hosts' \
      2>&1 1>&3
  )
  retcode=${?}
  # close fd
  exec 3>&-

  case "$retcode" in
  0) #Escolha efetivada
    echo "${RETVAL}"
    ;;
  255) #indica que aplicação será encerrada, pois foi cancelado pelo usuario
    echo "0"
    ;;
  *)
    echo "Valor de retorno #{?} foi inexperado em get_MainMenu()"
    exit 0
    ;;
  esac
}
