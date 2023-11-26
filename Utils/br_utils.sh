#!/bin/bash

BR_UTILS_IS_LOADED=True


### *** Private functions *** ###

_br_handle_param() {
    _br_handle_param_num=0
    _br_if=""
    _net_if=""
    while getopts "p:b:n:" _opt; do
        case "$_opt" in
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
                echo "Error in $0. Invalid option: -$OPTARG."
                exit 1
                ;;
            :)
                echo "Error in $0. Option -$OPTARG requires an argument."
                exit 1
                ;;
        esac
    done

    if [ "$_br_handle_param_num" -ne 1 ] && [ "$_br_handle_param_num" -ne 2 ]; then
        echo "Error in $0. Usage: $0 -n 1 -b br_if, or: $0 -n 2 -b br_if -n net_if."
        return 1
    fi

    if [ "$_br_handle_param_num" -eq 1 ] && [ "$_br_if" == "" ]; then
        echo "Error in $0. Usage: $0 -n 1 -b br_if."
        return 1
    fi

    if [ "$_br_handle_param_num" -eq 2 ] && [ "$_br_if" == "" ]; then
        echo "Error in $0. Usage: $0 -n 2 -b br_if -n net_if."
        return 1
    elif [ "$_br_handle_param_num" -eq 2 ] && [ "$_net_if" == "" ]; then
        echo "Error in $0. Usage: $0 -n 2 -b br_if -n net_if."
        return 1
    fi
}



### *** Public functions *** ###

br_setup() {
    _br_handle_param -n 2 $@ || return 1

    brctl show | grep -q "$_br_if" &> /dev/null
    if [ "$?" -ne 0 ]; then
        br_setdown || return 1
    fi

    sudo brctl addbr "$_br_if" &> /dev/null &&
        sudo brctl addif "$_br_if" "$_net_if" &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. Cannot create the bridge $_br_if."
        return 1
    fi

    sudo ip link set "$_br_if" up &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. Cannot force $_br_if up."
        return 1
    fi
}

br_setdown() {
    _br_handle_param -n 1 $@ || return 1

    sudo ip link set "$_br_if" down &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. Cannot force $_br_if down."
        return 1
    fi

    sudo brctl delbr "$_br_if" &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. Cannot delete the bridge $_br_if."
        return 1
    fi
}