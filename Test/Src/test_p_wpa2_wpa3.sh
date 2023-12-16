#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

TEST_ETH_IF_STRING="-e ethf3"


# Launch the AP
$AP_UI_PATH -c p:wpa2-wpa3 $TEST_ETH_IF_TRING

