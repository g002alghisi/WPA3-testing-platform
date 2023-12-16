#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh


# Launch the AP
$AP_UI_PATH -c p:wpa3-pk

