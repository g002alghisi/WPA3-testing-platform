# Test Comment

## General information

- Date:       2023-12-23 18:20:35
- Device:     Wpa_supplicant
- Script:     Test/Src/test_e_tofu_wpa2.sh
- Result:     Bad

## Comment

The supplicant trust both the first and the second certificate. Thus no TOFU mechanism is enforced for WPA2-Enterprise.

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
