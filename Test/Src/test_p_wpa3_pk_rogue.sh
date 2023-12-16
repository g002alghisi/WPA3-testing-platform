#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

# Launch the FAKE AP without SAE-PK
#$AP_UI_PATH -c p:fake-wpa3-pk


# Wait 5s
#sleep_with_dots 1


#but  Launch the REAL AP with SAE-PK
$AP_UI_PATH -c p:wpa3-pk -e enx9677d3c1defb


# Wait 5s
sleep_with_dots 1


# Launch the FAKE AP without SAE-PK
$AP_UI_PATH -c p:fake-wpa3-pk -e enx9677d3c1defb


