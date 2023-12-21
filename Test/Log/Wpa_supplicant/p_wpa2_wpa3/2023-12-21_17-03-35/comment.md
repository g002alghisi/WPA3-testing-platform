# Test Comment

## General information

- Date:       2023-12-21 17:03:35
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_wpa2_wpa3.sh
- Result:     Good

## Comment

Perfect. The supplicant connets with SAE.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa2_wpa3 -L $test_ui_log_tmp_dir

```
