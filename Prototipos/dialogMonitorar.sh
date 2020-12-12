#!/bin/bash
#a saida desta funçao eh um dos nomes
#falta pegar a saida e associar a cada item, como a saida 'e pelo namo creio eu seja mais facil de manipular'
function get_Monitora() {

    RETVAL=$(dialog --stdout \ 
        --checklist 'Marque as opçoes desejadas:' 0 0 0 \
        Cpu '' OFF \
        Memoria '' OFF \
        Latencia '' OFF \
        Up\Down '' OFF )
    
    if [ $? != 0 ]; then
        RETVAL=0
    else
        RETVAL=1
    
        
    fi
    echo ${RETVAL

}