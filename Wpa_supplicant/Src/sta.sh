#!/bin/bash
#set -x  # Debug mode.

### ### ### WPA-supplicant Station script ### ### ###
# The function of this script is setting up a Supplicant STA using wpa-supplicant.
# The security protocol used (WPA, WPA2, WPA3, ...) and the specific operational
# mode depends on the .conf file. The specific .conf file can be selected by
# means of an optiona parameter.
#
# The program is oranized as follow:
# - At the beginning, all the interfaces are manually specified. It has to be
#   highlighted that the WiFi interface has to match the one specified in the
#   .conf file.
# - It follows a setup phase, that consist in checking the state of the
#   WiFi interface.
# - The wpa-supplicant iprogram is then executed.
# - Finally, a setdown phase allows to dismiss the supplicant.

### Input
# The program accepts a single (optional) argument, to specify the security
# protocol to be used between WPA2-Personal and WPA3-Personal.
#       wpa_supplicant_sta.sh (wpa2|wpa3|wpa3-pk)



### *** Files, interfaces and constants *** ###

# Move to Wpa_supplicant/ folder
cd "$(dirname "$0")"
ecurrent_path=$(pwd)
while [[ "$current_path" != *"/Wpa_supplicant" ]]; do
    cd ..
    current_path=$(pwd)
done

wpa_supplicant="Build/wpa_supplicant"
#wpa_supplicant="wpa_supplicant"
wpa_supplicant_verbose_mode=0

wifi_if="wlx5ca6e63fe2da"

WPA_SUPPLICANT_WPA2_CONF_PATH="Conf/Minimal/wpa_supplicant_wpa2.conf"
WPA_SUPPLICANT_WPA3_CONF_PATH="Conf/Minimal/wpa_supplicant_wpa3.conf"
WPA_SUPPLICANT_WPA3_PK_CONF_PATH="Conf/Minimal/wpa_supplicant_wpa3_pk.conf"
WPA_SUPPLICANT_WPA2_WPA3="Conf/Minimal/wpa_supplicant_wpa2_wpa3.conf"
WPA_SUPPLICANT_CLI_CONF_PATH="Conf/Minimal/wpa_supplicant_cli.conf"


### *** Support *** ###

CYAN='\033[0;36m'
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'    # No color

log_info() {
    echo "INFO: $1"
}

log_success() {
    echo -e "${GREEN}Success.${NC}"
}

log_error() {
    echo -e "${RED}Error.${NC}"
}


# Silent execution function. Execute the code printing just stderr.
se() {
    $* >/dev/null
    return $?
}



### *** wpa_supplicant Config *** ###

wpa_supplicant_conf_file_check() {
    log_info "Looking for $wpa_supplicant_config_file... "
    if [ -e "$wpa_supplicant_config_file" ]; then
        log_success
    else
        log_success
        echo "wpa_supplicant configuration file $wpa_supplicant_config_file not found. Please check the file path."
        return 1
    fi
}



### *** WiFi *** ###&

wifi_check_if() {
    log_info "Checking WiFi interface... "

    wifi_if_status=$(nmcli -t device status | grep "$wifi_if" | grep ':wifi:')
    if [ $? -eq 0 ]; then
        log_success
    else
        log_error
        return 1
    fi
}


wifi_check_conn() {
    log_info "Checking WiFi connection... "

    wifi_current_conn=$(echo "$wifi_if_status" | grep ":connected:" | cut -d ':' -f 4)
    if [ -n "$wifi_current_conn" ]; then
        log_success
        log_info "$wifi_if currently connected to $wifi_current_conn. Disconnecting..."
        # Setting down the current connection. Can interfere with wpa_supplicant.
        if nmcli c down "$wifi_current_conn" > /dev/null; then
            log_success
        else
            log_error
            return 1
        fi
    else
        log_success
        log_info "$wifi_if currently not connected."
    fi
}



### *** NetworkManager *** ###

nm_start() {
    if systemctl is-active NetworkManager > /dev/null; then
        log_info "NetworkManager is already active."
    else
        log_info "Starting Network Manager... "
        if sudo systemctl start NetworkManager; then
            log_success
        else
            log_error
            return 1
        fi
    fi
}

nm_stop() {
    log_info "Stopping Network Manager... "
    if sudo systemctl stop NetworkManager; then
        log_success
    else
        log_error
        return 1
    fi
}



### *** Print AP information *** ###

sta_print_info() {
    echo "STA settings:"
    echo ""
    cat "$wpa_supplicant_config_file" | grep -vE '^(#|$)'
    echo ""
}



### ### ### Main section ### ### ###

sta_setup() {
    echo ""
    nm_start > /dev/null &&
    wpa_supplicant_conf_file_check &&
    wifi_check_if &&
    wifi_check_conn &&
    nm_stop
    echo ""
}

sta_run() {
    echo -e "${CYAN}Running Wpa-supplicant. Press Ctrl-C to stop.${NC}"
    echo ""
    sta_print_info
    echo ""
    sudo killall wpa_supplicant &> /dev/null
    if [ $cli_mode -eq 0 ]; then
        if [ $wpa_supplicant_verbose_mode -eq 0 ]; then
            sudo "$wpa_supplicant" -i "$wifi_if" -c "$wpa_supplicant_config_file"
        else
            sudo "$wpa_supplicant" -i "$wifi_if" -c "$wpa_supplicant_config_file" -d
        fi
    else
        sudo "$wpa_supplicant" -B -i "$wifi_if" -c "$wpa_supplicant_config_file"
        echo ""
        echo -e "${CYAN}Wpa_cli is running too...${NC}"
        echo ""
        sudo wpa_cli
    fi
    echo ""
    echo -e "${CYAN}Wpa_supplicant is stopped.${NC}"
    echo ""
}

sta_setdown() {
    sudo killall wpa_supplicant &> /dev/null
    sudo killall wpa_cli &> /dev/null
    nm_start
    echo ""
}



main() {
     while getopts "w:d" opt; do
        case $opt in
            w)
                wifi_if="$OPTARG"
                ;;
            d)
                wpa_supplicant_verbose_mode=1
                ;;
            \?)
                echo "Invalid option: -$OPTARG" >&2
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument." >&2
                exit 1
                ;;
        esac
    done

    shift $((OPTIND-1))

    if [ $# -ne 1 ]; then
        echo "Usage: $0 [-w wifi_if] wpa2|wpa3|wpa3-pk|cli"
        exit 1
    fi


    cli_mode=0
    security_protocol="$1"
    case $security_protocol in
        "wpa2")
            wpa_supplicant_config_file="$WPA_SUPPLICANT_WPA2_CONF_PATH"
            ;;
        "wpa3")
            wpa_supplicant_config_file="$WPA_SUPPLICANT_WPA3_CONF_PATH"
            ;;
        "wpa3-pk")
            wpa_supplicant_config_file="$WPA_SUPPLICANT_WPA3_PK_CONF_PATH"
            ;;
        "wpa2-wpa3")
            wpa_supplicant_config_file="$WPA_SUPPLICANT_WPA2_WPA3"
            ;;
       	"cli")
            wpa_supplicant_config_file="$WPA_SUPPLICANT_CLI_CONF_PATH"
            cli_mode=1
            ;;
        *)
            echo -e "Invalid parameter (wpa2|wpa3|wpa3-pk)."
            exit 1
            ;;
    esac

    # Update the cached credentials (this avoid the insertion of the sudo password
    # during the execution of the successive commands).
    sudo -v

    sta_setup &&
    sta_run
    sta_setdown

}


main $@
