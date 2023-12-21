# Test Comment

## General information

- Date:       2023-12-21 17:57:08
- Device:     Wpa_supplicant
- Script:     Test/Src/test_p_downgrade_wpa3_pk.sh
- Result:     Good

## Comment

Perfect. Setting "update=1" inside the supplicant .conf file prevent it to join the ROGUE AP also after having restarted wpa_supplicant. Indeed, "sae_pk=1" string is added to the conf file, thus SAE-PK is required for that SSID.

## Test script

```bash
#!/bin/bash
#set -x  # Debug mode


# launch the REAL AP with SAE-PK
$ap_ui_path -c p_wpa3_pk -L $test_ui_log_tmp_dir


# Sleep 1 s
sleep 1


# launch the FAKE AP with WPA3 (not SAE-PK)
$ap_ui_path -c p_fake_wpa3_pk -l $test_ui_log_tmp_dir
```
