#!/bin/bash
#set -x  # debug mode


# Home. DO NOT TERMINATE WITH "/"
HOME_DIR="Hostapd-test"

go_home() {
    cd "$(dirname "$HOME_DIR")"
    current_path=$(pwd)
    while [[ "$current_path" != *"$HOME_DIR" ]] && [[ "$current_path" != "/" ]]; do
        cd ..
        current_path=$(pwd)
    done

    if [[ "$current_path" == "/" ]]; then
        echo "Error in $0, reached "/" position. Wrong HOME_DIR"
        return 1
    fi
}

# All the file positions are now relative to the Main Repository DIR.
# Load utils scripts
go_home
source Utils/Src/general_utils.sh

# Tmp DIR to store the certificates
tmp_dir="Freeradius/Tmp"

# Specify the file relatively to the $as_conf_dir
ca_cert_pem="certs/ca.pem"
ca_cert_der="certs/ca.der"
clien_cert_pem="certs/client.pem"
clien_cert_crt="certs/client.crt"
clien_key="certs/client.key"


### *** AS *** ###

as_setup() {
    # Check if $as_conf_dir ends with "/"
    if [[ "$as_conf_dir" != */ ]]; then
        as_conf_dir="$as_conf_dir""/"
    fi
    # Add to the cert variables the root part (respect Home)
    ca_cert_pem="$as_conf_dir""$ca_cert_pem"
    ca_cert_der="$as_conf_dir""$ca_cert_der"
    clien_cert_crt="$as_conf_dir""$clien_cert_crt"
    clien_cert_pem="$as_conf_dir""$clien_cert_pem"
    clien_key="$as_conf_dir""$clien_key"

    # Check AS config directory
    log_info "Looking for $as_conf_dir..."
    file_exists -d $as_conf_dir && log_success || { log_error; return 1; }
   
    # Copying certs and keys in Tmp/Conf* directory
    tmp_dir="$tmp_dir/$(basename $as_conf_dir)"
    log_info "Copying certs inside $tmp_dir/..."
        mkdir -p "$tmp_dir" &&
        cp "$ca_cert_pem" "$tmp_dir" &&
        cp "$ca_cert_der" "$tmp_dir" &&
        cp "$clien_cert_crt" "$tmp_dir" &&
        cp "$clien_cert_pem" "$tmp_dir" &&
        cp "$clien_key" "$tmp_dir"

    if [ "$?" -eq 0 ]; then
        log_success
    else
        log_error
        return 1
    fi
    
    # Kill previous instances of Freeradius
    sudo killall freeradius &> /dev/null

    return 0
}

as_run() {
    log_title "Running FreeRADIUS. Press Ctrl-C to stop."

    if [ "$as_verbose_mode" -eq 0 ]; then
        sudo freeradius -f -d "$as_conf_dir"
    else
        sudo freeradius -d "$as_conf_dir" -X
    fi

    log_title "FreeRADIUS is stopped."
}

as_setdown() {
    # If something goes wrong, try to kill freeradius
    sudo killall freeradius &> /dev/null
}



### *** Main section *** ###

main() {
    as_ip_addr=""
    as_port=""
    as_conf_dir=""
    as_verbose_mode=0
    while getopts "c:vd" opt; do
        case $opt in
            c)
                as_conf_dir="$OPTARG"
                ;;
            v)
                as_verbose_mode=1
                ;;
            d)
                # Enable debug for the bash script
                set -x
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
    OPTIND=1

    # Check if the input is valid (the user have to insert at lease the
    #   configuration dir path)
    if [ "$as_conf_dir" == "" ]; then
        echo "Usage: $0 -c conf_dir [-v] [-d]."
        exit 1
    fi

    # Update the cached credentials (this avoid the insertion of the sudo password
    #   during the execution of the successive commands)
    sudo -v

    # Hide keyboard input
    stty -echo

    # If the setup fails, then do not run, but skip this phase and execute
    #   the setdown
    echo ""
    as_setup &&
    as_run
    as_setdown
    echo ""

    # Show keyboard input
    stty echo
}

main $@
