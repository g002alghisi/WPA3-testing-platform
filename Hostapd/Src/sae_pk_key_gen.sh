#!/bin/bash
#set -x  # Debug mode


# Home. DO NOT TERMINATE WITH "/"
HOME_DIR="WPA3-testing-platform"

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
tmp_dir="Hostapd/Tmp"

# Configuration files list
CONF_LIST_PATH="Hostapd/Conf/conf_list.txt"

# sae_pk_gen file path
SAE_PK_GEN_PATH="Hostapd/Build/sae_pk_gen"



### *** Key Generator *** ###

key_gen_setup() {
    # Create tmp_dir to store generated data
    print_info "Creating $tmp_dir/ temporary directory..."
    tmp_dir="$tmp_dir/$ssid" && mkdir -p "$tmp_dir" &&
        print_success || { print_error; return 1; }

    # Generate a private key inside tmp_dir
    print_info "Generating $ssid.der private key inside $tmp_dir..."
    openssl ecparam -name prime256v1 -genkey -noout -out "$ssid.der" -outform der &&
        mv "$ssid.der" "$tmp_dir" &&
        print_success || { print_error; return 1; }

    # Paths to the .der and .pk files
    ssid_der="$tmp_dir/$ssid.der"
    ssid_pk="$tmp_dir/$ssid.pk"
}

key_gen_run() {
    print_title "Running sae_pk_gen. Press Ctrl-C to stop."

    # Derive the password from ssid.der
    print_info "Generating $ssid.pk SAE-PK key inside $tmp_dir..."
    $SAE_PK_GEN_PATH "$ssid_der" "$sec" "$ssid" | tee "$ssid_pk"
    
    #The program will print a special string that starts like this:
    #    sae_password=abcd-defg-hijk|pk=...
    #This string can be directly copied in the hostapd.conf file and will automatically enable WPA3 with SAE-PK.

    print_title "sae_pk_gen is stopped."
}



### *** Main *** ###

main() {
    # Check the number of parameters.
    if [ $# -ne 2 ]; then
        echo "Usage: $0 <Sec:3|5> <ssid_name>."
        exit 1
    fi

    # Get parameters
    sec="$1"
    ssid="$2"

    echo ""
    key_gen_setup &&
    key_gen_run
}

main $@
