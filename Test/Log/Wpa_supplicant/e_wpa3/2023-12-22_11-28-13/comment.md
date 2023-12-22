# Test Comment

## General information

- Date:       2023-12-22 11:28:13
- Device:     Wpa_supplicant
- Script:     Test/Src/test_e_wpa3.sh
- Result:     Good

## Comment

Perfect. This time it was in verbose mode and the execution is very lean.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AS in a new window, but wait for hostapd to be running
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_wpa3 -v -l $test_ui_log_tmp_dir" 

# Launch the AP
$ap_ui_path -c e_wpa3 -L $test_ui_log_tmp_dir

# Try to kill freeradius
sudo pkill freeradius &> /dev/null ||
    sudo pkill as.ui &> /dev/null ||
    sudo pkill as_ui.sh &> /dev/null

```
