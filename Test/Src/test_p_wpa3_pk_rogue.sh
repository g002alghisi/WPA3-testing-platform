#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# Launch the ROGUE AP with SAE-PK and wrokg modifier/pP keys
#$AP_UI_PATH -c p:rogue-wpa3-pk


# Wait 1s
#sleep_with_dots 1


#but  Launch the REAL AP with SAE-PK
$AP_UI_PATH -c p:wpa3-pk


# Wait 1s
sleep_with_dots 1


# Launch the ROGUE AP with SAE-PK and wrokg modifier/pP keys
$AP_UI_PATH -c p:rogue-wpa3-pk

