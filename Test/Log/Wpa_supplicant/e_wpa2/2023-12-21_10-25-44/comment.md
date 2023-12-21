# Test Comment

## General information

- Date:       2023-12-21 10:25:43
- Device:     Wpa_supplicant
- Script:     Test/Src/test_e_wpa2.sh
- Result:     Bad

## Comment

Wpa_supplicant does not work with enterprise. Hostapd prints "Unsupported authentication algorithm". Better to try again in verbose mode.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AS in a new window, but wait for hostapd to be running
exec_new_term -w hostapd -c "$AS_UI_PATH -c e_wpa2 -v -l $test_ui_log_tmp_dir"

# Launch the AP
$AP_UI_PATH -c e_wpa2 -L $test_ui_log_tmp_dir

# Try to kill all the terminal windows created, hostapd and freeradius
sudo pkill -P $$ &> /dev/null
```
