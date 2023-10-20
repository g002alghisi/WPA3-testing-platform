#!/bin/bash

# Update the cached credentials without running a command
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
config_file="../Config/hostapd.conf"


setup() {
    stty -echo  # Hide ^C

    current_eth_connection="$(nmcli -t c show --active | grep ethernet | cut -d ':' -f 1)"

    if [ -z "$current_eth_connection" ]; then
        echo "Currently not connected to any Ethernet." 
    else
        echo "Disconnecting from $current_eth_connection [Eth]... "
        nmcli c down "$current_eth_connection"   
    fi
    echo ""


    current_wifi_connection="$(nmcli -t c show --active | grep wifi | cut -d ':' -f 1)"

    if [ -z "$current_wifi_connection" ]; then
        echo "Currently not connected to any WiFi." 
    else
        echo "Disconnecting from $current_wifi_connection [WiFi]..."
        nmcli c down "$current_wifi_connection"   
    fi
    echo ""

}


launch_hostapd() {
    echo -e "${YELLOW}Hostapd is up. Press Ctrl-C to terminate...${NC}"
    echo ""

    sudo hostapd "$config_file"
}


setdown() {
    echo "" # New line
    echo -e "${PURPLE}Hostapd is down.${NC}"
    echo ""

    stty echo   # Show ^C
    
    exit 0
}



### Main section of the program
setup

launch_hostapd

setdown

