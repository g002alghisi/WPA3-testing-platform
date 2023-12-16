#!/bin/bash

NM_UTILS_IS_LOADED=True

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Public functions *** ###

nm_start() {
    sudo systemctl start NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
    echo "$FUNCNAME(): Cannot star NetworkManager." 
        return "$CODE_KO"
    fi
}

nm_stop() {
    sudo systemctl stop NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME(): Cannot stop NetworkManager." 
        return "$CODE_KO"
    fi
}

