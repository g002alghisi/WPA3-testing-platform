# Test Comment

## General information

- Date:       2023-12-25 11:01:28
- Device:     Raspberry_Pi_4
- Script:     Test/Src/test_p_wpa3.sh
- Result:     Bad

## Comment

It does not connect.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa3 -L $test_ui_log_tmp_dir

```
