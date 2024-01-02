# Test Comment

## General information

- Date:       2024-01-02 19:27:37
- Device:     Raspberry_Pi_4_wpa_nmcli
- Script:     Test/Src/test_e_wpa3.sh
- Result:     Bad

## Comment

It does not connect if PMF is set as required on the supplicant.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AS in a new window, but wait for hostapd to be running
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_wpa3 -v -l $test_ui_log_tmp_dir" 

# Launch the REAL WPA3 AP
$ap_ui_path -c e_wpa3 -L $test_ui_log_tmp_dir

# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null

```
