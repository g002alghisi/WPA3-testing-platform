#!/bin/bash

NM_UTILS_IS_LOADED=True


### *** Public functions *** ###

nm_start() {
    sudo systemctl start NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
    echo "Error in $0. Cannot star NetworkManager." 
        return 1
    fi
}

nm_stop() {
    sudo systemctl stop NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. Cannot stop NetworkManager." 
        return 1
    fi
}

