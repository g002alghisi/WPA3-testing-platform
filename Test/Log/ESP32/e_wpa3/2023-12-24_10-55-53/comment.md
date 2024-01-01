# Test Comment

## General information

- Date:       2023-12-24 10:55:52
- Device:     ESP32
- Script:     Test/Src/test_e_wpa3.sh
- Result:     Good

## Comment

The modified program do not connect to the fake WPA3-Enterprise network.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AS in a new window, but wait for hostapd to be running
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_wpa3 -v -l $test_ui_log_tmp_dir" 

# Launch the REAL WPA3 AP
$ap_ui_path -c e_fake_wpa3 -L $test_ui_log_tmp_dir
# Modified just for this test! e_fake_wpa3 is a WPA-Enterprise with PMF disable.
# The supplicant with a WPA3 profile should not connect!

# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null

```
