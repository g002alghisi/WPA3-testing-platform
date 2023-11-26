#!/bin/bash
#set -x  # debug mode

# Home
HOME_FOLDER="Freeradius"

# Tmp
TMP_FOLDER="Tmp"

# Specify the file relatively to the $as_conf_folder
CA_CERT_PEM="certs/ca.pem"
CA_CERT_DER="certs/ca.der"


### ### ### Logging ### ### ###s

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



### ### ### Utilities ### ### ###

go_home() {
    cd "$(dirname "$HOME_FOLDER")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_FOLDER" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done
}



### ### ### AS ### ### ###

as_conf_folder_check() {
    log_info "Looking for $as_conf_folder... "
    if [ -e "$as_conf_folder" ]; then
        log_success
    else
        log_success
        echo "FreeRADIUS configuration file $as_conf_folder not found. Please check the file path."
        return 1
    fi
}

as_cp_cert_files() {
    cp "$CA_CERT_PEM" "$TMP_FOLDER"
    cp "$CA_CERT_DER" "$TMP_FOLDER"
}

as_setup() {
    echo ""
    as_conf_folder_check &&
    as_cp_cert_files
}

as_run() {
    echo ""
    echo -e "${CYAN}Running FreeRADIUS. Press Ctrl-C to stop.${NC}"
    echo ""
    #as_print_info
    echo ""
    killall freeradius &> /dev/null
    if [ "$as_verbose_mode" -eq 0 ]; then
        sudo freeradius -d "$as_conf_folder"
    else
        sudo freeradius -d "$as_conf_folder" -X
    fi
    echo ""
    echo -e "${CYAN}FreeRADIUS is stopped.${NC}"
    echo ""
}

as_setdown() {
    echo ""
}



### ### ### Main section ### ### ###

main() {
    go_home

    as_ip_addr=""
    as_port=""
    as_conf_folder=""
    as_verbose_mode=0
    while getopts "d:X" opt; do
        case $opt in
            d)
                as_conf_folder="$OPTARG"
                ;;
            X)
                as_verbose_mode=1
                ;;
            \?)
                echo "Invalid option: -$OPTARG"
                exit 1
                ;;
            :)
                echo "Option -$OPTARG requires an argument."
                exit 1
                ;;
        esac
    done

    if [ "$as_conf_folder" == "" ]; then
        echo "Usage: $0 -d conf_dir [-X]"
        #echo "Usage: $0 -i ip_addr -p port -d conf_dir [-X]"
        exit 1
    fi

    # Check if $as_conf_folder ends with "/"
    if [[ "$as_conf_folder" != */ ]]; then
        as_conf_folder="$as_conf_folder""/"
    fi
    CA_CERT_PEM="$as_conf_folder""$CA_CERT_PEM"
    CA_CERT_DER="$as_conf_folder""$CA_CERT_DER"

    stty -echo

    as_setup &&
    as_run
    as_setdown

    stty echo
}

main "$@"
