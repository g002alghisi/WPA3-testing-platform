# Test Comment

## General information

- Date:       2023-12-26 10:37:52
- Device:     Raspberry_Pi_4
- Script:     Test/Src/test_p_wpa3.sh
- Result:     Bad

## Comment

This time the network profile has been manually configured by selecting the option "WPA3 Personal". I really wonder why to include this configuration option if it does not work.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa3 -L $test_ui_log_tmp_dir

```
