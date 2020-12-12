#!/bin/bash

clear
SSRM_BASEDIR="${PWD}/src"
echo ${SSRM_BASEDIR}

yad --width=400 --title="Dados do host" --text="Por favor informe os seguintes detalhes:" \
--image="${SSRM_BASEDIR}/ifpb.png" \
--form  \
--field="Last name" --entry-text="default1" \
--field="First name"  --entry-text=STRING  \
--field="Date of birth":DT \
--field="Last holiday":CB \
"" "" "Click calendar icon" 'Gold Coast!Bali!Phuket!Sydney'