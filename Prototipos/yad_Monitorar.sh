#!/bin/bash

function yadSelectMonitorar() {
    ret=$(
        yad --list \
            --image="ifpb_3.png" \
            --title="Monitorar Hosts" --mouse --column="#" --column="Opção" --column="Descrição" --width=480 --height=250 \
            1 "Uso de CPU" "" \
            2 "Uso de Memoria" "" \
            3 "Latencia" "" \
            4 "Up e Down da Rede" "" \
    )

    echo ${ret}
}
yadSelectMonitorar