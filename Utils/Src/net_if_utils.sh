#!/bin/bash

NET_IF_UTILS_IS_LOADED=True

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Private functions *** ###

_net_if_handle_param() {
    _net_if=""
    _net_if_type=""
    while getopts "e:w:" opt; do
        case $opt in
            w)
                _net_if="$OPTARG"
                _net_if_type="w"
                ;;
            e)
                _net_if="$OPTARG"
                _net_if_type="e"
                ;;
            \?)
                echo "Error in $FUNCNAME. Invalid option: -$OPTARG."
                return $CODE_ERROR
                ;;
            :)
                echo "Error in $FUNCNAME. Option -$OPTARG requires an argument."
                return $CODE_ERROR
                ;;
        esac
    done
    OPTIND=1

    if [ "$_net_if" == "" ]; then
        echo "Error in $FUNCNAME. Usage: $FUNCNAME < -w wifi_if | -e eth_if >"
        return $CODE_ERROR
    fi
}



### *** Public functions *** ###

net_if_exists() {
    _net_if_handle_param $@ || return "$?"

    systemctl is-active NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $FUNCNAME. NetworkManager not active."
        return "$CODE_ERROR"
    fi

    # Exists?
    case "$_net_if_type" in
        w)
            nmcli -t device status | grep "$_net_if" | \
                grep ':wifi:' &> /dev/null
            if [ "$?" -ne 0 ]; then
                echo "$FUNCNAME: Interface $_net_if_type:$_net_if does not exist."
                return "$CODE_KO"
            fi
            ;;
        e)
            nmcli -t device status | grep "$_net_if" | \
                grep ':ethernet:' &> /dev/null
            if [ "$?" -ne 0 ]; then
                echo "$FUNCNAME: Interface $_net_if_type:$_net_if does not exist."
                return "$CODE_KO"
            fi
            ;;
        \?)
            echo "Error in $FUNCNAME. Invalid option: -$OPTARG."
            return "$CODE_ERROR"
            ;;
        :)
            echo "Error in $FUNCNAME. Option -$OPTARG requires an argument."
            return "$CODE_ERROR"
            ;;    
    esac
    OPTIND=1
}

net_if_force_up() {
    net_if_exists $@ || return "$?"

    # Force up
    sudo ip link set "$_net_if" up &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "$FUNCNAME: Cannot set $_net_if up."
        return "$CODE_KO"
    fi
}

net_if_is_connected() {
    net_if_exists $@ || return "$?"

    systemctl is-active NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $FUNCNAME. NetworkManager not active."
        return "$CODE_ERROR"
    fi

    _net_if_status=""
    case "$_net_if_type" in
        w)
            _net_if_status="$(nmcli -t device status | grep "$_net_if" | \
                grep ':wifi:' | cut -d ':' -f 4)"
            ;;
        e)
            _net_if_status="$(nmcli -t device status | grep "$_net_if" | \
                grep ':wifi:' | cut -d ':' -f 4)"
            ;;
        \?)
            echo "Error in $FUNCNAME. Invalid option: -$OPTARG."
            return "$CODE_ERROR"
            ;;
        :)
            echo "Error in $FUNCNAME. Option -$OPTARG requires an argument."
            return "$CODE_ERROR"
            ;;    
    esac

    if [ "$_net_if_status" != "connected" ]; then
        echo "$FUNCNAME: $_net_if is not connected."
        return "$CODE_KO"
    fi
}