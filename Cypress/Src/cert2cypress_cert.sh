#!/bin/bash
#set -x  # Debug mode


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


# Temporary directory and file paths. DO NOT TERMINATE WITH "/"
tmp_dir="Cypress/Tmp"

# Configuration files list
CONF_LIST_PATH="Freeradius/Conf/conf_list.txt"

# Cert files and keys
ca_pem="ca.pem"
client_pem="client.pem"
client_key="client.key"


### *** Cert 2 Cypress Cert Convertion *** ###
c2cc_convert() {
    tmp_file=""
    cert_file=""

    # Check input parameter
    if [ "$#" -ne 1 ]; then
        echo "Usage: $FUNCNAME() cert_string."
        retunr $CODE_ERROR
    fi

    cert_file="$1"

    # Adjust tmp_file path acordingly the name of cert_file
    tmp_file="$tmp_dir/$(basename "$cert_file").txt"

    # Copy cert_file inside tmp_file
    cat "$cert_file" > "$tmp_file"

    # Save content of cert_file inside tmp.txt
    cat $cert_file > "$tmp_file" &&

    # Add " char at the beginning of each line
    sed -i "s/^/\"/" "$tmp_file" &&

    # Add \r\n"\ chars at the end of each line
    sed -i 's/$/\\r\\n"\\/' "$tmp_file" &&

    # Add \0"\ at the end of tmp.txt
    echo '"\0"\' >> "$tmp_file" &&

    # Add \0" at the end of tmp.txt
    echo '"\0"' >> "$tmp_file"

    if [ "$?" -ne 0 ]; then
        echo "Error in $FUNCNAME(): cannot convert the file."
        return $CODE_KO
    fi

    # If everything is okay, print the result
    cat "$tmp_file" && return $CODE_OK
}

c2cc_setup() {
    # Get configuration file from conf_list
    log_info "Fetching configuration directory associated to $as_conf_string..."
    as_conf_dir="$(get_from_list -f "$CONF_LIST_PATH" -s "$as_conf_string")" &&
        log_success || { echo "$as_conf_dir"; log_error; return 1; }

    as_cert_dir="$as_conf_dir/certs"

    # Check AS config directory
    log_info "Looking for $as_cert_dir..."
    file_exists -d $as_conf_dir && log_success || { log_error; return 1; }

    # Create tmp_dir to store temporary files
    log_info "Creating $tmp_dir/ temporary directory."
    # Copy basename of as_cert_dir for the tmp_dir. DO NOT TERMINATE WITH "/"
    tmp_dir="$tmp_dir/$(basename "$as_conf_dir")" && mkdir -p "$tmp_dir" &&
        log_success || { log_error; return 1; }
}

c2cc_run() {
    echo ""

    # Check ca.pem file
    ca_pem="$as_cert_dir/$ca_pem"
    log_info "Looking for $ca_pem..."
    file_exists -f $ca_pem && log_success || { log_error; return 1; }

    # Converting ca.pem file
    log_info "Converting $ca_pem..."
    ca_pem_cypress="$(c2cc_convert "$ca_pem")" && log_success || { echo "$ca_pem_cypress"; log_error; return 1; }

    log_title "Certificate: ca.pem"
    echo "$ca_pem_cypress"

    echo ""

    # Check client.pem file
    client_pem="$as_cert_dir/$client_pem"
    log_info "Looking for $client_pem..."
    file_exists -f $client_pem && log_success || { log_error; return 1; }

    # Converting client.pem file
    log_info "Converting $client_pem..."
    client_pem_cypress="$(c2cc_convert "$client_pem")" && log_success || { echo "$client_pem_cypress"; log_error; return 1; }

    log_title "Certificate: client.pem"
    echo "$client_pem_cypress"

    echo ""

    # Check client.key file
    client_key="$as_cert_dir/$client_key"
    log_info "Looking for $client_key..."
    file_exists -f $client_key && log_success || { log_error; return 1; }

    # Converting client.key file
    log_info "Converting $client_key..."
    client_key_cypress="$(c2cc_convert "$client_key")" && log_success || { echo "$client_key_cypress"; log_error; return 1; }

    log_title "Certificate: client.key"
    echo "$client_key_cypress"

    echo ""
}



### *** Main *** ###

main() {
    as_conf_dir=""
    as_conf_string=""
    as_cert_dir=""

    while getopts "c:" opt; do
        case $opt in
            c)
                as_conf_string="$OPTARG"
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

    # Check if the input is valid (the user have to insert at least the
    #   configuration string)
    if [ "$as_conf_string" == "" ]; then
        echo "Usage: $0 -c as_conf_string."
        exit 1
    fi

    echo ""
    c2cc_setup &&
    c2cc_run

    return 0
}

main $@
