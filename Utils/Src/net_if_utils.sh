#!/bin/bash

NET_IF_UTILS_IS_LOADED=True



### *** Private functions *** ###

_net_if_handle_param() {
    _net_if=""
    _net_it_type=""
    while getopts "w:e:" _opt; do
        case "$_opt" in
            w)
                _net_if="$OPTARG"
                _net_it_type="w"
                ;;
            e)
                _net_if="$OPTARG"
                _net_it_type="e"
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

    if [ "$_net_if" == "" ]; then
        echo "Error in $0. Usage: $0 < -w wifi_if | -e eth_if | -b br_if >"
        return 1
    fi
}



### *** Public functions *** ###

net_if_exists() {
    _net_if_handle_param $@ || return 1

    systemctl is-active NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. NetworkManager not active."
        return 1
    fi

    _net_if_exists=False
    # Exists?
    case "$_net_if_type" in
        w)
            nmcli -t device status | grep "$wifi_if" | \
                grep ':wifi:' &> /dev/null
            _net_if_exists=True
            ;;
        e)
            nmcli -t device status | grep "$wifi_if" | \
                grep ':ethernet:' &> /dev/null
            _net_if_exists=True
            ;;
        \?)
            echo "Error in $0. Invalid option: -$OPTARG."
            return 1
            ;;
        :)
            echo "Error in $0. Option -$OPTARG requires an argument."
            return 1
            ;;    
    esac

    if [ -n "$_net_if_exists" ]; then
        echo "Error in $0. Interface $_net_if_type:$_net_if does not exist."
        return 1
    fi
}

net_if_force_up() {
    net_if_exists $@ || return 1

    # Force up
    sudo ip link set "$_net_if" up &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. Cannot set $_net_if up."
        return 1
    fi
}

net_if_is_connected() {
    net_if_exists $@ || return 1

    systemctl is-active NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $0. NetworkManager not active."
        return 1
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
            echo "Error in $0. Invalid option: -$OPTARG."
            return 1
            ;;
        :)
            echo "Error in $0. Option -$OPTARG requires an argument."
            return 1
            ;;    
    esac

    if [ "$_net_if_status" != "connected" ]; then
        return 1
    fi
}

