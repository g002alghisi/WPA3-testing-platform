# Test Comment

## General information

- Date:       2023-12-22 15:29:28
- Device:     @test_ui_device
- Script:     Test/Src/test_e_wpa3.sh
- Result:     Bad

## Comment

Wpa_cli does not support UOSC.

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
