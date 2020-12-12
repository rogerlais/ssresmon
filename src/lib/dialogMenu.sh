#!/bin/bash

#este infliz so quer pegar assim com o get_Menu no final
function get_MainMenu() {
  RETVAL=$(dialog --stdout --title "Menu Principal" \
    --menu "Informe uma opçao:" \
    0 0 0 \
    1 'Monitorar Hosts' \
    2 'Inserir Hosts' \
    3 'Editar Hosts' \
    4 'Remover Hosts')

  if ! $?; then
    echo "0" #indica que aplicação será encerrada
  else
    echo "${RETVAL}"
  fi
}
