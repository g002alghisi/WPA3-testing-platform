#!/bin/bash
# set -x # Debug mode

##### ##### ##### SAE-PK Key generator ##### ##### #####
# In order to work with hostapd using SAE-PK, the special key has to be generated.
# To do so, the program sae_pk_gen (from the hostapd repository) is leveraged.
#
# These instructions are available at https://github.com/vanhoefm/hostap-wpa3.

### Input
# - <3|5>, Sec parameter.
# - <ssid_name>

### Output
# The script prints the output of the sae_pk_gen program.
# In addition, it saves the publik-private key .der file and the sae_pk_gen output in the Tmp/ folder.


# Check the number of parameters.
if [ $# -ne 2 ]; then
    echo "Usage: $0 <3|5> <ssid_name>"
    exit 1
fi

# Assegna i parametri alle variabili
sec="$1"
ssid="$2"

# Move to Hostapd/ folder
cd "$(dirname "$0")"
ecurrent_path=$(pwd)
while [[ "$current_path" != *"/Hostapd" ]]; do
    cd ..
    current_path=$(pwd)
done


# Create a temp folder to store generated data.
tmp_dir="Tmp/$ssid/"
mkdir -p "$tmp_dir"

# First generate a private key inside Tmp/ folder
openssl ecparam -name prime256v1 -genkey -noout -out "$ssid.der" -outform der
mv "$ssid.der" "$tmp_dir"

# Now derive the password from it:
./Build/sae_pk_gen "$tmp_dir""$ssid.der" "$sec" "$ssid" | tee "$tmp_dir""$ssid"".pk"


#The program will print a special string that starts like this:
#    sae_password=abcd-defg-hijk|pk=...
#This string can be directly copied in the hostapd.conf file and will automatically enable WPA3 with SAE-PK.
