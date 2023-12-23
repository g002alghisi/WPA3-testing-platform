# Test Comment

## General information

- Date:       2023-12-23 18:28:23
- Device:     Wpa_supplicant
- Script:     Test/Src/test_e_rogue_wpa3.sh
- Result:     Good

## Comment

Perfect. The supplicant refuses to connect to the rogue AP and prints "TLS: Certificate verification failed, error 19 (self-signed certificate in certificate chain) depth 1 for '/C=FR/ST=Radius/L=Somewhere/O=Example Inc./emailAddress=admin@example.org/CN=Example Certificate Authority'".

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the REAL AS in a new window, but wait for hostapd to be running
exec_new_term -w "hostapd" -c "$AS_UI_PATH -c e_wpa3 -v -l $test_ui_log_tmp_dir"

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
