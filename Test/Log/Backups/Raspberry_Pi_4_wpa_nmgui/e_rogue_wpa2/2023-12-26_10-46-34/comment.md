# Test Comment

## General information

- Date:       2023-12-26 10:46:34
- Device:     Raspberry_Pi_4
- Script:     Test/Src/test_e_rogue_wpa2.sh
- Result:     Good

## Comment

Perfect. The Raspberry allows you to edit the network profile in the same way as Ubuntu.
By selecting "WPA2/WPA3 Enterprise" a configuration window appears where the user can select the desired EAP Method.
It is possible also to select "skip server certificate". However, if a certificate is selected, the supplicant properly verifies it and does not conenct to rogue AP.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the REAL AS in a new window, but wait for hostapd to be running
exec_new_term -w hostapd -c "$AS_UI_PATH -c e_wpa2 -v -l $test_ui_log_tmp_dir"

# Launch the REAL AP
$ap_ui_path -c e_wpa2 -L "$test_ui_log_tmp_dir"

# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null

# Sleep for 1s
sleep 1


# Launch the ROGUE AS in a new window
exec_new_term -w hostapd -c "$AS_UI_PATH -c e_rogue_wpa2 -v -l $test_ui_log_tmp_dir"

# Launch the ROGUE AP
$ap_ui_path -c e_rogue_wpa2 -l "$test_ui_log_tmp_dir"


# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null
```
