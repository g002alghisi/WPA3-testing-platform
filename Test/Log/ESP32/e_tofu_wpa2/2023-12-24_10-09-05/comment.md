# Test Comment

## General information

- Date:       2023-12-24 10:09:05
- Device:     ESP32
- Script:     Test/Src/test_e_tofu_wpa2.sh
- Result:     Bad

## Comment

By using the modified version of `wifi_enterprise`, it was possible not to load any ca cert, but the result is quite poor: the supplicant does not validate the certificate at all.

The original program was modified in order not to load the ca cert, but buffer the one recieved from the server.
The default menuconfig allows the user to select Validate Server Certificate, but the only thing that it does is to load the ca cert in the main program or not.
There is no function to configure the WPA module to trust only the first recieved certificate.


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
