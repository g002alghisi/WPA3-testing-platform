# Test Comment

## General information

- Date:       2024-02-22 14:59:13
- Device:     Raspberry_Pi_4_wpa_nmgui
- Script:     Test/Src/test_p_wpa3.sh
- Result:     Bad

## Comment

It doesn't work, as exected. This test was done by flashing again the SD card with Raspbian OS.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# Launch the AP
$ap_ui_path -c p_wpa3 -L $test_ui_log_tmp_dir

```
