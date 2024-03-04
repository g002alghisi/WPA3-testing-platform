# Test Comment

## General information

- Date:       2023-12-26 17:56:27
- Device:     Raspberry_Pi_4
- Script:     Test/Src/test_e_tofu_wpa3.sh
- Result:     Good/Bad

## Comment

Please add a description...

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the REAL AS in a new window, but wait for hostapd to be running
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_tofu_wpa3 -v -l $test_ui_log_tmp_dir"

# Launch the REAL AP
$ap_ui_path -c e_wpa3 -L "$test_ui_log_tmp_dir"

# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null


# Sleep for 1s
sleep 1


# Launch the ROGUE AS in a new window
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_rogue_wpa3 -v -l $test_ui_log_tmp_dir"

# Launch the ROGUE AP
$ap_ui_path -c e_rogue_wpa3 -l "$test_ui_log_tmp_dir"

# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null
```
