# Test Comment

## General information

- Date:       2023-12-26 11:02:16
- Device:     Raspberry_Pi_4
- Script:     Test/Src/test_e_tofu_wpa2.sh
- Result:     Bad

## Comment

There is no TOFU Policy if the certificate is not selected during the configuration phase.
At the configuration time, if a method that requires a certificate is not selected, then it is not possible to save the setting.
The only way not to select a certificate is by checking the "[ ] No certificate is required" option.
However, in this case no validation of the certificate is done at all, and no TOFU Policy is present for WPA2 network.
The result is that the supplicant joins the rogue AP even if it has previously connected to the real AP.

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
