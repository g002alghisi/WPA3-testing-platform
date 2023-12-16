#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

TEST_ETH_IF_STRING="-e eth-usb-f3"


# Launch the AP
$AP_UI_PATH -c p:wpa3-pk $TEST_ETH_IF_STRING

