#!/bin/bash

# set -x

# Specify personal_hostapd.conf file path.
config_file_conf="../Conf/personal_hostapd.conf"
if [ $? -ne 0 ]; then
    echo "Cannot find personal_hostap.conf configuration file."
    exit 1
fi


# Specify personal_ap.ini file path.
config_file_ini="../Conf/personal_ap.ini"
if [ $? -ne 0 ]; then
    echo "Cannot find personal_ap.ini configuration file."
    exit 1
fi

config_file_ini_parse () {
    # Get a file like:
    #   [general]ssid=Hostapd-AP
    #   [general]passphrase=argoargoargo
    #   [general]protocol=wpa2
    #   [wpa2]mfp=1
    #   [wpa3]bp=1
    #   [wpa3]ocv=0
    #   [wpa3]pwe_alg=2
    #   [wpa2/3]td=0
    sed 's/;.*//' "$config_file_ini" |
    awk '/\[/{prefix=$0; next} $1{print prefix $0}' > tmp.txt
}


general_parse () {
    # Handle [general] section.
    grep "\[general\]" tmp.txt > general_tmp.txt &&
        general_ssid="$(grep "ssid" general_tmp.txt | cut -d "=" -f 2)" &&
        general_passphrase="$(grep "passphrase" general_tmp.txt | cut -d "=" -f 2)" &&
        general_protocol="$(grep "protocol" general_tmp.txt | cut -d "=" -f 2)" &&
        rm general_tmp.txt
    if [ $? -ne 0 ]; then
        echo "Error reading the [general] section of $config_file_ini."
        return 1
    fi

    if [ -z "$general_ssid" ]; then
        echo "Error reading the [general] section of $config_file_ini. Invalid SSID."
        return 1
    elif [ "${#general_passphrase}" -lt 8 ]; then
        echo "Error reading the [general] section of $config_file_ini. Invalid passphrase."
        return 1
    elif [ "$general_protocol" != "wpa2" ] && [ "$general_protocol" != "wpa3" ] && \
        [ "$general_protocol" != "wpa2/3" ]; then
        echo "Error reading the [general] section of $config_file_ini. Invalid protocol."
        return 1
    fi
}

wpa2_parse () {
    # Handle [wpa2] section.
    grep "\[wpa2\]" tmp.txt > wpa2_tmp.txt &&
        wpa2_mfp="$(grep "mfp" wpa2_tmp.txt | cut -d "=" -f 2)" &&
        rm wpa2_tmp.txt
    if [ $? -ne 0 ]; then
        echo "Error reading the [wpa2] section of $config_file_ini."
        return 1
    fi

    if [ $wpa2_mfp -gt 1 ]; then
        echo "Error reading the [wpa2] section of $config_file_ini. Invalid mfp field."
        return 1
    fi
}

wpa3_parse () {
    # Handle [wpa3] section.
    grep "\[wpa3\]" tmp.txt > wpa3_tmp.txt &&
        wpa3_bp="$(grep "bp" tmp_wp3.txt | cut -d "=" -f 2)" &&
        wpa3_ocv="$(grep "ocv" wpa3_tmp.txt | cut -d "=" -f 2)" &&
        wpa3_pwe_alg="$(grep "pwe_alg" wpa3_tmp.txt | cut -d "=" -f 2)" &&
        rm wpa3_tmp.txt
    if [ $? -ne 0 ]; then
        echo "Error reading the [wpa3] section of $config_file_ini."
        return 1
    fi

    if [ $wpa3_bp -gt 1 ]; then
        echo "Error reading the [wpa3] section of $config_file_ini. Invalid bp field."
        return 1
    elif [ $wpa3_ocv -gt 1 ]; then
        echo "Error reading the [wpa3] section of $config_file_ini. Invalid ocv field."
        return 1
    elif [ $wpa3_pwe_alg -gt 2 ]; then
        echo "Error reading the [wpa3] section of $config_file_ini. Invalid pwe_alg field."
        return 1
    fi
}

wpa23_parse () {
    # Handle [wpa2/3] section.
    grep "\[wpa2/3\]" tmp.txt > wpa23_tmp.txt &&
        wpa23_td="$(grep "mfp" wpa23_tmp.txt | cut -d "=" -f 2)" &&
        rm wpa2_tmp.txt
    if [ $? - ne 0 ]; then
        echo "Error reading the [wpa2/3] section of $config_file_ini."
    fi

    if [ $wpa23_td -gt 1 ]; then
        echo "Error reading the [wpa2/3] section of $config_file_ini. Invalid td field."
        return 1
    fi
}


sub_line() {
    if [ $# -ne 2 ]; then
        echo "Error using sub_line(). Not the right number of parameters."
        return 1
    fi
    sed -i '/^[^#].*$1/s/.*/$2/' "$config_file_conf"
}


### *** Main section *** ###
config_file_ini_parse || exit 1

general_parse || exit 1

sub_line "wpa_passphrase=" "wpa_passphrase=$general_passphrase"
sub_line "ssid=" "ssid=$general_ssid"

case $general_protocol in
    "wpa2")
        sub_line "wpa_key_mgmt=" "wpa_key_mgmt=WPA-PSK"
        sub_line "ieee80211w=" "ieee80211w=$wpa2_mfp"
        sub_line "beacon_prot=" "beacon_prot=0"
        sub_line "ocv=" "ocv=0"
        sub_line "sae_require_mfp=" "sae_require_mfp=0"
        sub_line "transition_disable=" "transition_disable=0"
        ;;
    "wpa3")
        sub_line "wpa_key_mgmt=" "wpa_key_mgmt=SAE"
        sub_line "ieee80211w=" "ieee80211w=2"
        sub_line "beacon_prot=" "beacon_prot=$wpa3_bp"
        sub_line "ocv=" "ocv=$wpa3_ocv"
        sub_line "sae_require_mfp=" "sae_require_mfp=1"
        sub_line "sae_pwe=" "sae_pwe=$wpa3_pwe_alg"
        sub_line "transition_disable=" "transition_disable=0"
        ;;
    "wpa2/3")
        sub_line "wpa_key_mgmt=" "wpa_key_mgmt=WPA-PSK SAE"
        sub_line "ieee80211w=" "ieee80211w=1"
        sub_line "beacon_prot=" "beacon_prot=0"
        sub_line "ocv=" "ocv=0"
        sub_line "sae_require_mfp=" "sae_require_mfp=1"
        sub_line "transition_disable=" "transition_disable=$wpa23_td"
        ;;
    *)
        echo "Error in the case structure."
        exit 1
        ;;
esac


# Run the Acces point
./ap.sh
