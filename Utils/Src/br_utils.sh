#!/bin/bash

BR_UTILS_IS_LOADED=True

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Private functions *** ###

_br_handle_param() {
    _br_handle_param_num=0
    while getopts "p:b:n:" opt; do
        case $opt in
            p)
                _br_handle_param_num="$OPTARG"
                ;;
            b)
                _br_if="$OPTARG"
                ;;
            n)
                _net_if="$OPTARG"
                ;;
            \?)
                echo "Error in $FUNCNAME. Invalid option: -$OPTARG."
                exit "$CODE_ERROR"
                ;;
            :)
                echo "Error in $FUNCNAME. Option -$OPTARG requires an argument."
                exit "$CODE_ERROR"
                ;;
        esac
    done
    OPTIND=1

    if [ "$_br_handle_param_num" -ne 1 ] && [ "$_br_handle_param_num" -ne 2 ]; then
        echo "Error in $FUNCNAME. Usage: $FUNCNAME -n 1 -b br_if, or: $FUNCNAME -n 2 -b br_if -n net_if."
        return "$CODE_ERROR"
    fi

    if [ "$_br_handle_param_num" -eq 1 ] && [ "$_br_if" == "" ]; then
        echo "Error in $FUNCNAME. Usage: $FUNCNAME -n 1 -b br_if."
        return "$CODE_ERROR"
    fi

    if [ "$_br_handle_param_num" -eq 2 ] && [ "$_br_if" == "" ]; then
        echo "Error in $FUNCNAME. Usage: $FUNCNAME -n 2 -b br_if -n net_if."
        return "$CODE_ERROR"
    elif [ "$_br_handle_param_num" -eq 2 ] && [ "$_net_if" == "" ]; then
        echo "Error in $FUNCNAME. Usage: $FUNCNAME -n 2 -b br_if -n net_if."
        return "$CODE_ERROR"
    fi
}

br_exists() {
    _br_handle_param -p 1 -b $@ || return "$?"

    brctl show | grep -q "$_br_if" &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME: Bridge $_br_if does not exists."
        return "$CODE_KO"
    fi
}



### *** Public functions *** ###

br_setup() {
    _br_handle_param -p 1 -b $@ || return "$?"
    br_setdown "$_br_if" &> /dev/null

    sudo brctl addbr "$_br_if" &> /dev/null 
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME: Cannot create the bridge $_br_if."
        return "$CODE_KO"
    fi
}

br_add_if() {
    _br_handle_param -p 2 $@ || return "$?"
    br_exists "$_br_if" || return "$?"

    sudo brctl addif "$_br_if" "$_net_if" &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME: Cannot add $_net_if to the bridge $_br_if."
        return "$CODE_KO"
    fi
}

br_setdown() {
    _br_handle_param -p 1 -b $@ || return "$?"
    br_exists "$_br_if" || return "$?"

    sudo ip link set "$_br_if" down &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME: Cannot force $_br_if down."
        return "$CODE_KO"
    fi

    sudo brctl delbr "$_br_if" &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME: Cannot delete the bridge $_br_if."
        return "$CODE_KO"
    fi
}