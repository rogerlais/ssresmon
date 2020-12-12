#!/bin/bash

clear
SSRM_BASEDIR="${PWD}/src"
echo ${SSRM_BASEDIR}

yad --width=400 --title="Dados do host" --text="Por favor informe os seguintes detalhes:" \
--image="${SSRM_BASEDIR}/ifpb.jpg" \
--form --date-format="%-d %B %Y" \
--field="Last name" \
--field="First name" \
--field="Date of birth":DT \
--field="Last holiday":CB \
"" "" "Click calendar icon" 'Gold Coast!Bali!Phuket!Sydney'