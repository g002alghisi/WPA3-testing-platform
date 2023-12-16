#!/bin/bash
#set -x

NET_IF_UTILS_IS_LOADED=True

CODE_OK=0
CODE_KO=1
CODE_ERROR=2


### *** Private functions *** ###

_net_if_handle_param() {
    _net_if=""
    _net_if_type=""
    _net_if_channel=0
    while getopts "e:w:c:" opt; do
        case $opt in
            w)
                _net_if="$OPTARG"
                _net_if_type="w"
                ;;
            e)
                _net_if="$OPTARG"
                _net_if_type="e"
                ;;
            c)
                _net_if_channel="$OPTARG"
                ;;
            \?)
                echo "Error in $FUNCNAME(). Invalid option: -$OPTARG."
                return $CODE_ERROR
                ;;
            :)
                echo "Error in $FUNCNAME(). Option -$OPTARG requires an argument."
                return $CODE_ERROR
                ;;
        esac
    done
    OPTIND=1

    if [ "$_net_if" == "" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() < -w wifi_if | -e eth_if >"
        return $CODE_ERROR
    fi
}



### *** Public functions *** ###

net_if_exists() {
    _net_if_handle_param $@ || return "$?"

    # Exists?
    case "$_net_if_type" in
        w)
            ip -br l | awk '$1 !~ "lo|vir|et" { print $1 }' | grep -e "\b$_net_if\b" &> /dev/null
            if [ "$?" -ne 0 ]; then
                echo "$FUNCNAME(): Interface $_net_if_type:$_net_if does not exist."
                return "$CODE_KO"
            fi
            ;;
        e)
            ip -br l | awk '$1 !~ "lo|vir|wl" { print $1 }' | grep -e "\b$_net_if\b" &> /dev/null
            if [ "$?" -ne 0 ]; then
                echo "$FUNCNAME(): Interface $_net_if_type:$_net_if does not exist."
                return "$CODE_KO"
            fi
            ;;
        \?)
            echo "Error in $FUNCNAME(). Invalid option: -$OPTARG."
            return "$CODE_ERROR"
            ;;
        :)
            echo "Error in $FUNCNAME(). Option -$OPTARG requires an argument."
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
        echo "$FUNCNAME(): Cannot set $_net_if up."
        return "$CODE_KO"
    fi
}

net_if_is_connected() {
    net_if_exists $@ || return "$?"

    systemctl is-active NetworkManager &> /dev/null
    if [ "$?" -ne 0 ]; then
        echo "Error in $FUNCNAME(). NetworkManager not active."
        return "$CODE_ERROR"
    fi

    _net_if_status=""
    case "$_net_if_type" in
        w)
            _net_if_status="$(nmcli -t device status | grep -e "\b$_net_if\b" | \
                grep ':wifi:')"
            ;;
        e)
            _net_if_status="$(nmcli -t device status | grep "\b$_net_if\b" | \
                grep ':ethernet:')"
            ;;
        \?)
            echo "Error in $FUNCNAME(). Invalid option: -$OPTARG."
            return "$CODE_ERROR"
            ;;
        :)
            echo "Error in $FUNCNAME(). Option -$OPTARG requires an argument."
            return "$CODE_ERROR"
            ;;    
    esac

    if [ "$(echo $_net_if_status | cut -d ':' -f 3)" != "connected" ]; then
        echo "$FUNCNAME(): $_net_if is not connected."
        return "$CODE_KO"
    else
    	echo "$_net_if_status"
    	return "$CODE_OK"
    fi
}

# Just for wireless interfaces
net_if_set_monitor_mode() {
    net_if_exists $@ || return "$?"

    # Check that type is wireless
    if [ "$_net_if_type" != "w" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() -w wifi_if [-c channel]."
        return $CODE_ERROR
    fi

    # Kill all the processes that can interfere, then turn in monitor mode
    sudo airmon-ng check kill > /dev/null &&
    if [ "$channel" -eq 0 ]; then
        sudo airmon-ng start "$_net_if" > /dev/null
    else
        sudo airmon-ng start "$_net_if" "$_net_if_channel" > /dev/null
    fi

    if [ "$?" -ne 0 ]; then 
        echo "Error in $FUNCNAME(). Cannot set $_net_if in monitor mode."
        return $CODE_KO
    else
        return $CODE_OK
    fi

    # If "airmon-ng start" cmd is successful, the name of the interface could
    # change to "net_if+mon", where "+" stands for append.
    # This is quite important when setting default mode is needed.
}

net_if_set_default_mode() {
    # This time, "manually" parse the input instead of using net_if_exists()
    # directly. This is because "airmon-ng start" can change the name of the
    # interface appending "mon".
    _net_if_handle_param $@ || return "$?"

    # Check that type is wireless
    if [ "$_net_if_type" != "w" ]; then
        echo "Error in $FUNCNAME(). Usage: $FUNCNAME() -w wifi_if."
        return $CODE_ERROR
    fi

    # First check without final "mon"
    _net_if_exists_output="$(net_if_exists -w "$_net_if")"
    case $? in
        $CODE_ERROR)
            echo "$_net_if_exists_output"
            return $CODE_ERROR
            ;;
        $CODE_KO)
            # No-op. The interface do not exists with final "mon".
            sleep 0.1
            ;;
        $CODE_OK)
            # set default mode
            sudo airmon-ng stop "$_net_if" > /dev/null &&
                sudo ip link set "$_net_if" up > /dev/null &&
                return $CODE_OK ||
                { echo "Error in $FUNCNAME(). Cannot set $_net_if in default mode.";
                return $CODE_KO; }
            ;;
    esac

    # Then try with final "mon".
    # Be careful, because net_if_exists() updates the global name of _net_if
    # appending "mon". Thus these two case-switch structures cannot be swapped.
    # Moreover, create _net_if_old to save the original name.
    _net_if_old="$_net_if"
    _net_if="$_net_if""mon"
    net_if_exists -w "$_net_if"
    case $? in
        $CODE_ERROR)
            echo "$_net_if_exists_output"
            return $CODE_ERROR
            ;;
        $CODE_KO)
            echo "$FUNCNAME(): Interface $_net_if_type:$_net_if_old does not exist."
            return $CODE_KO;
            ;;
        $CODE_OK)
            # set default mode
            sudo airmon-ng stop "$_net_if" > /dev/null &&
                sudo ip link set "$_net_if_old" up > /dev/null &&
                return $CODE_OK ||
                { echo "Error in $FUNCNAME(). Cannot set $_net_if in default mode.";
                return $CODE_KO; }
            ;;
    esac
}
