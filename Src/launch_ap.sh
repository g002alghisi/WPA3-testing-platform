#!/bin/bash

### Full Acces Point ###
# The function of this script is setting up an AP using hostapd and, by means
# of a bridge, get acces to the ethernet network, getting DHCP services and
# acces to the Internet.
#
# The program is oranized as follow:
# - At the beginning, all the interfaces are manually specified. It has to be 
#   highlighted that the WiFi interface has to match the one specified in the
#   hostapd.conf file.
# - It follows a setup phase, ...
# - The hostapd deamon is then executed, ...
# - Finally, a setdown phase allows to dismiss the bridge, ... 


# Update the cached credentials (this avoid the insertion of the sudo password
# during the execution of the successive commands).
sudo -v


# Specify colors for echo.
RED='\033[0;31m'        # Red
BLUE='\033[0;34m'       # Blue
PURPLE='\033[0;35m'     # Purple
YELLOW='\033[0;33m'     # Yellow
BRED='\033[1;31m'       # Bold red
BBLUE='\033[1;34m'      # Bold blue
BPURPLE='\033[1;35m'    # Bold purple
BYELLOW='\033[1;33m'    # Bold yellow
NC='\033[0m'            # No Color


# Specify the position of the hostapd config files.
config_file="../Conf/hostapd.conf"
if [ -e "$config_file" ]; then
    echo "Hostapd configuration file found."
else
    echo "Cannot find hostapd configuration file."
    exit 1
fi

# Specify the network interfaces.
eth_if="enp4s0f1"
wifi_if="wlp3s0"

# Specify bridge name.
br_if="br-ap"

# Creating exit_status support variable
exit_status=0


eth_check() {
    echo ""
    echo -n "Looking for Ethernet $eth_if interface... "
    eth_if_status="$(nmcli -t device status | grep $eth_if | grep ':ethernet:')"
    if [ -z "$eth_if_status" ]; then
        echo "Ethernet $eth_if interface not found."
        exit_status=1
        setdown 
    else
        echo "Found."
    fi

    eth_current_conn="$(echo $eth_if_status | cut -d ':' -f 4)"
    if [ -z "$eth_current_conn" ]; then
        echo "Ethernet $eth_if not connected. Please connect."
        exit_status=1
        setdown 
    else
        echo "$eth_if connected to $eth_current_conn."
    fi
}


wifi_check() {
    echo ""
    echo -n "Looking for WiFi $wifi_if interface... "
    wifi_if_status="$(nmcli -t device status | grep $wifi_if | grep ':wifi:')"
    if [ -z "$wifi_if_status" ]; then
        echo "WiFi $wifi_if interface not found."
        exit_status=1
        setdown 
    else
        echo "Found."
    fi

    wifi_current_conn="$(echo $wifi_if_status | grep $wifi_if | cut -d ':' -f 4)"
    if [ -z "$wifi_current_conn" ]; then
        echo "$wifi_if not connected to any WiFi." 
    else
        echo -n "$wifi_if connected to $wifi_current_conn. Disconnecting... "
        # Setting down current connection. Can interfere with hostapd.
        nmcli c down "$wifi_current_conn" > /dev/null
        if [ $? -eq 0 ]; then
            echo "Done."
        else
            echo "Error disconnecting $wifi_if from $wifi_current_conn."
            exit_status=1
            setdown
        fi
    fi
    echo ""
}



setup() {
    eth_check

    wifi_check

    echo -n "Stopping Network Manager... "
    # Disable nmcli. It can interfere with brctl.
    sudo systemctl stop NetworkManager > /dev/null 
    if [ $? -eq 0 ]; then
        echo "Done."
    else
        echo "Error setting down Network Manager."
        exit_status=1
        setdown
    fi

    echo -n "Setting up the bridge br-ap... "
    sudo brctl addbr "$br_if" > /dev/null ; brctl_output="$?"
    sudo brctl addif "$br_if" "$eth_if" > /dev/null ; brctl_output="$?"
    # sudo brctl addif "$br_if" "$wifi_if" > /dev/null ; brctl_output="$?"

    # Apparently, the bridge interface has been created, but not brought up.
    # To force it, the ip command can be used.
    sudo ip link set "$br_if" up > /dev/null ; brctl_output="$?"
    if [ "$brctl_output" -eq 0 ]; then
        echo "Done."
    else
        echo "Error setting up the bridge."
        exit_status=1
        setdown
    fi
}


launch_hostapd() {
    echo -e "${PURPLE}Hostapd is running. Press Ctrl-C to terminate...${NC}"
    echo ""

    sudo hostapd "$config_file"
    if [ "$?" -eq 1 ]; then
        exit_status=1
    fi

    echo ""
    echo -e "${PURPLE}Hostapd is stopped.${NC}"
}


setdown() {
    echo ""
    echo -n "Setting down the bridge br-ap... "
    sudo ip link set "$br_if" down > /dev/null ; brctl_output="$?"
    sudo brctl delbr br-ap > /dev/null ; brctl_output="$?"
    if [ "$brctl_output" -eq 0 ]; then
        echo "Done."
    else
        echo "Error setting down the bridge."
        exit_status=1
    fi

    sudo systemctl start NetworkManager # Restart nmcli.
    echo -n "Restarting Network Manager... "
    sudo systemctl start NetworkManager > /dev/null 
    if [ $? -eq 0 ]; then
        echo "Done."
    else
        echo "Error setting up Network Manager."
        exit_status=1
    fi

    exit "$exit_status"
}



### Main section of the program
setup

launch_hostapd

setdown

