# Test Comment

## General information

- Date:       2023-12-20 19:03:08
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_wpa3_pk.sh
- Result:     Good

## Comment

Ok, works as expected. It notifies the reception of thransition disable 0x02 bit.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$AP_UI_PATH -c p_wpa3_pk -L $test_ui_log_tmp_dir

```
