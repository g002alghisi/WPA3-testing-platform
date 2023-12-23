# Test Modalities and Results

1. [Devices](#devices)
2. [Tests](#tests)
3. [Results](#results)

## Devices

- Cypress Board CYW954907AEVAL1F, Wi-Fi module based on CYW54907 device.
- Keystudio ESP32 Core Board, with ESP32-WROOM-32 and Espressif IDF v5.1.2.
- Raspberry Pi 4, [add information about version].
- Raspberry Pi Pico W [add information about version].
- iPad Air 2022, iPadOS 17.1.2.
- POCO F3, Android 13 TKQ1.220829.002, MIUI Global 14.0.9.
- Ubuntu Desktop 23.10.1, running on a Virtual Machine (VirtualBOX) and set up USB passthrough for the TP-Link Archer T2U v3 Wi-Fi dongle.
- Windows 11, running on a Virtual Machine (VirtualBOX) and set up USB passthrough for the TP-Link Archer T2U v3 Wi-Fi dongle.
- TP-Link Archer T2U v3 Wi-Fi dongle, chipset RTL8811AU, driver: [morrownr 8821au](https://github.com/morrownr/8821au-20210708) for Linux, [official](https://www.tp-link.com/it/support/download/archer-t2u/) for Windows.

## Tests

### Personal

- Test WPA3-Personal by means of [`test_p_wpa3.sh`](Src/test_p_wpa3.sh). Create a WPA3 network and check if devices are able to connect. Allow both PWE methods (Hunting-and-Pecking and Hash-to-curve).

    1. Set up the WPA3 AP.
    2. Make the device join the network.

- Test WPA3-Personal SAE-PK by means of [`test_p_rogue_wpa3_pk.sh`](Src/test_p_rogue_wpa3.sh). Create a WPA3 network with SAE-PK and verify which devices already support it. Threaten it to join a rogue WPA3 network.

    1. Set up the REAL AP with WPA3 and SAE-PK.
    2. Make the device join the network.
    3. Teardown the genuine AP an set up a ROGUE AP with same PK and correct modifier, but wrong private key.
    4. Check if the device connects to the rogue network.

- Test WPA2/3-Personal and transition disable WPA3 -> WPA2 by means of [`test_p_downgrade_wpa2_wpa3.sh`](Src/test_p_downgrade_wpa2_wpa3.sh).

    1. Set up a fake WPA3 AP that does not use PMF.
    2. Turn on the device.
    3. Set up the real AP with WPA2/3 and Transition Disable WPA3 -> WPA2 enabled.
    4. The device joins the network with a WPA2/3 profile.
    5. The real AP is setdown and a rogue AP with just WPA2 is created.
    6. Check if the device connects to the rogue network.
    7. If not, turn off the device.
    8. Set up the rogue AP with just WPA2.
    9. Turn on the device and try to join the network.

- Test WPA3-Personal SAE-PK and Transition disable SAE-PK -> SAE by means of [`test_p_downgrade_wpa3_pk.sh`](Src/test_p_downgrade_wpa3_pk.sh).

    1. Set up the real AP with WPA3, SAE-PK and Transition Disable SAE-PK -> SAE enabled.
    2. Select `Automatic Mode` for SAE-PK on the supplicant device.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP with just SAE (not SAE-PK) is created.
    5. Check if the device connects to the rogue network.
    6. If not, turn off the device.
    7. Set up the rogue AP with just SAE.
    8. Turn on the device and try to join the network.

### Enterprise

- Test WPA2-Enterprise by means of [`test_e_rogue_wpa2.sh`](Src/test_e_rogue_wpa2.sh). Verify if the device distrusts the fake server certificates.

    1. Prepare the client Network Profile and install the root certificate (`ca.pem`).
    2. Set up the real AP and AS.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and a rogue AS) with WPA2 is created.
    5. Check if the device connects to the rogue network.

- Test WPA2-Enterprise TOFU by means of [`test_e_tofu_wpa2.sh`](Src/test_e_tofu_wpa2.sh). Often the supplicant allows the user to not specify any ca cert, and only the first certificate recieved is trusted during successive authentication rounds.

    1. Do not prepare the client Network Profile and do not install the root certificate (`ca.pem`).
    2. Set up the real AP and AS. The certifiates do not include the TOD TOFU Policy from WPA3.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and a rogue AS) with WPA2 is created.
    5. Check if the device connects to the rogue network.

- Test WP3-Enterprise by means of [`test_e_rogue_wpa3.sh`](Src/test_e_rogue_wpa3.sh)

    1. Prepare the client Network Profile and install the root certificate (`ca.pem`).
    2. Set up the real AP and AS.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and a rogue AS) with WPA2 is created.
    5. Check if the device connects to the rogue network.

- Test WPA3-Enterprise UOSC by means of [`test_e_uosc_wpa3.sh`](Src/test_e_uosc_wpa3.sh).

    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`).
    2. Set up the AP and AS. The certificates do not include TOD Policies.
    3. Check it the device automatically joins the network. If not, control if it prompts any pop-up message asking the user to trust the server certificate.
    4. The real AP is setdown and a rogue AP (and AS) with WPA3 is created.
    5. Check if the device connects to the rogue network. If not, verify that the supplicant prompts any warning message or UOSC request.

- Test WPA3-Enterprise TOD by means of [`test_e_tofu_wpa3.sh`](Src/test_e_tofu_wpa3.sh).
    In this case, the examination is geared towards the Trust Override Disable Policies of the supplicant.
    In particular, TOD-TOFU policy is enforced by means of the server certificate (`server.pem`).

    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`).
    2. Set up the real AP and AS. The certificates do include the TOD TOFU Policy from WPA3
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and AS) with WPA3 is created.
    5. Check if the device connects to the rogue network. If not, verify that the supplicant has inhibited UOSC. The system shall not enquire to trust the new certificate from the rogue AP.

## Results

### Template

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA2-Enterprise TOFU
    - [ ] Test WPA3-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOFU

### Wpa_supplicant

- Personal

    - [x] Test WPA3-Personal: ___OK___
    
    - [x] Test WPA3-Personal SAE-PK: ___OK___
    
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___OK___
        - By selecting `update=1` in the configuration, the supplicant resists the attack even after its reboot.
        
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___OK___
        - By selecting `update=1` in the configuration, the supplicant resists the attack even after its reboot.
            In particular, the resulting configuration presents `sae_pk=1` (SAE-PK only mode) from `sae_pk=0` (SAE-PK in automatic mode)

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___

    - [ ] Test WPA2-Enterprise TOFU

    - [ ] Test WPA3-Enterprise
    
    - [x] Test WPA3-Enterprise UOSC: ___!!___
        - Neither `wpa_cli` nor `wpa_gui` implement UOSC. If a root certificate is specified, they just trust the one recieved from the server without asking anything to the user.
        	And what if `update=1` and a root ca cert is defined?
            
    - [ ] Test WPA3-Enterprise TOFU

### Cypress Board CYW954907AEVAL1F

- Personal

    - [ ] Test WPA3-Personal
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE

        Moreover, rebooting the ESP32 causes the supplicant to forget about the Transition disable bit; this causes the device to join the rogue AP with WPA2.
- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA2-Enterprise TOFU
    - [ ] Test WPA3-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### Keystudio ESP32 Core Board

- Personal

    - [x] Test WPA3-Personal: ___OK___

    - [x] Test WPA3-Personal SAE-PK: ___OK___

    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___~~___
        - By selecting `[x] Transition disable` via `menuconfig`, the supplicant resists the attack. However, after the reboot it forgets about the recieved Transition disable information and joins the rogue network.

    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___!!___
        - If the device is configured with SAE-PK Automatic mode, then it joins the rogue AP also after having recieved the Transition disable for SAE-PK -> SAE. Moreover, Automatic mode is the default behaviour for the example `station` provided by Espressif. The menuconfig does indeed allow to enable SAE-PK, but not to select the mode (and the default one is Automatic mode).

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___

    - [ ] Test WPA2-Enterprise TOFU

    - [x] Test WPA3-Enterprise UOSC: ___oo___
        - There is no user interaction for the default program. However, The `wifi_enterprise` example is quite coherent to the WPA3 Standard. Indeed, if WPA2 is selected, the user is free to skip the server certificate validation by means of a checkbox; if WPA3 is selected, this option is not available anymore.
            Another interesting feature is that it is not allowed to select weak EAP methods for the external authentication (just TLS, TTLS and PEAP). However, the inner protocol cannot be choosen.

    - [ ] Test WPA3-Enterprise TOD Mechanism: ___oo___.
        - Cannot be tested: it requires UOSC to be implemented.

