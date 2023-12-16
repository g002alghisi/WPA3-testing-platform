#!/bin/bash
#set -x  # Debug mode

# Surce test_setup.sh to prepare the environment
source test_setup.sh

TEST_ETH_IF_STRING="-e ethf3"


# launch the FAKE AP with WPA3 (not SAE-PK)
#$AP_UI_PATH -c p:fake-wpa3-pk $TEST_ETH_IF_TRING


# Wait 1s
#sleep_with_dots 1


# launch the REAL AP with SAE-PK
$AP_UI_PATH -c p:wpa3-pk $TEST_ETH_IF_TRING


# Wait 1s
sleep_with_dots 1


# launch the FAKE AP with WPA3 (not SAE-PK)
$AP_UI_PATH -c p:fake-wpa3-pk $TEST_ETH_IF_TRING
