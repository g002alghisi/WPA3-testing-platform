#!/bin/bash
#set -x  # debug mode

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



### ### ### AS ### ### ###

as_conf_dir_check() {
    log_info "Looking for $as_conf_dir... "
    if [ -e "$as_conf_dir" ]; then
        log_success
    else
        log_success
        echo "FreeRADIUS configuration file $as_conf_dir not found. Please check the file path."
        return 1
    fi
}

as_print_info() {
    echo "AS settings:"
    echo ""
    cat "$as_conf_dir" | grep -vE '^(#|$)'
    echo ""
}

as_setup() {
    echo ""
    as_conf_dir_check
}

as_run() {
    echo ""
    echo -e "${CYAN}Running FreeRADIUS. Press Ctrl-C to stop.${NC}"
    echo ""
    #as_print_info
    echo ""
    killall freeradius &> /dev/null
    if [ "$as_verbose_mode" -eq 0 ]; then
        sudo freeradius -d "$as_conf_dir"
    else
        sudo freeradius -d "$as_conf_dir" -X
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
    as_ip_addr=""
    as_port=""
    as_conf_dir=""
    as_verbose_mode=0
    while getopts "i:p:d:X" opt; do
        case $opt in
            d)
                as_conf_dir="$OPTARG"
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

    if [ "$as_conf_dir" == "" ]; then
        echo "Usage: $0 -i ip_addr -p port -d conf_dir [-X]"
        exit 1
    fi

    stty -echo

    as_setup &&
    as_run
    as_setdown

    stty echo
}

main "$@"
