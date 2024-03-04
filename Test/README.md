# Test Modalities and Results

1. [Devices](#devices)
2. [Tests](#tests)
3. [Results](#results)

## Devices

- Cypress Board CYW954907AEVAL1F, Wi-Fi module based on CYW54907 device.
- Keystudio ESP32 Core Board, with ESP32-WROOM-32 and Espressif IDF v5.1.2.
- Raspberry Pi 4.
- Raspberry Pi Pico W.
- Ubuntu Desktop 23.10.1, running on a Virtual Machine (VirtualBOX) and set up USB passthrough for the TP-Link Archer T2U v3 Wi-Fi dongle.
- Windows 11, running on a Virtual Machine (VirtualBOX) and set up USB passthrough for the TP-Link Archer T2U v3 Wi-Fi dongle.
- TP-Link Archer T2U v3 Wi-Fi dongle, chipset RTL8811AU, driver: [morrownr 8821au](https://github.com/morrownr/8821au-20210708) for Linux, [official](https://www.tp-link.com/it/support/download/archer-t2u/) for Windows.

## Tests

### Personal

- Test WPA3-Personal by means of [`test_p_wpa3.sh`](Src/test_p_wpa3.sh).

    1. Set up the WPA3 AP.
    2. Configure the device with a WPA3-Personal profile and check if it joins the network.

- Test WPA3-Personal SAE-PK by means of [`test_p_rogue_wpa3_pk.sh`](Src/test_p_rogue_wpa3.sh).

    1. Set up the REAL AP with WPA3 and SAE-PK.
    2. Configure the device to enable SAE-PK and check if it joins the network.
    3. Teardown the genuine AP an set up a ROGUE AP with the same PK and correct modifier, but wrong private key.
    4. Check if the device connects to the ROGUE network.

- Test WPA2/3-Personal and transition disable WPA3 -> WPA2 by means of [`test_p_downgrade_wpa2_wpa3.sh`](Src/test_p_downgrade_wpa2_wpa3.sh).

    1. Set up the REAL AP with WPA2/3 and Transition Disable WPA3 -> WPA2 enabled.
    2. Configure the device with a WPA2 profile and check if it joins the network.
    3. The REAL AP is setdown and the ROGUE AP with just WPA2 is created.
    4. Check if the device connects to the rogue network (it should not).
    5. If not, turn off the device.
    6. Set up the rogue AP with just WPA2.
    7. Turn on the device and check if it connects (it should not).

- Test WPA3-Personal SAE-PK Automatic mode and Transition disable SAE-PK -> SAE by means of [`test_p_downgrade_wpa3_pk.sh`](Src/test_p_downgrade_wpa3_pk.sh).

    1. Set up the FAKE AP with WPA3 and a SAE-PK-like password, but not SAE-PK.
    2. Configure the device with a WPA3 profile, SAE-PK enabled in `Automatic Mode` and check if it joins the network (it should not).
    1. The ROGUE AP is setdown and the real AP with WPA3, SAE-PK and Transition Disable SAE-PK -> SAE enabled is activated.
    3. Check if the device joins the network (it should).
    4. The REAL AP is setdown and set up the FAKE AP with WPA3 and a SAE-PK-like password, but not SAE-PK.
    5. Check if the device connects (it should not).
    6. If not, turn off the device.
    8. Turn on again the supplicant and check if it joins the FAKE AP.

### Enterprise

- Test WPA2-Enterprise by means of [`test_e_rogue_wpa2.sh`](Src/test_e_rogue_wpa2.sh). Verify if the device distrusts the fake server certificates.

    1. Configure the client Network Profile and install the root certificate (`ca.pem`).
    2. Set up the REAL AP and AS.
    3. Check if the device joins the network (it should).
    4. The REAL AP is setdown and a ROGUE AP (and a ROGUE AS) with WPA2 is created.
    5. Check if the supplicant connects to the rogue network (it should not not).

- Test WPA2-Enterprise TOFU by means of [`test_e_tofu_wpa2.sh`](Src/test_e_tofu_wpa2.sh). Often the supplicant allows the user to not specify any ca cert, and by default it automatically trusts only the first certificate recieved.

    1. Do not configure the client Network Profile and do not install the root certificate (`ca.pem`).
    2. Set up the REAL AP and AS. The certifiates do not include the TOD TOFU Policy from WPA3.
    3. Check if the device joins the network, giving eventually the permission.
    4. The REAL AP is setdown and a ROGUE AP (and a ROGUE AS) with WPA2 is created.
    5. Check if the device connects to the rogue network (it should not).
    6. If it does not connect, turn the device off.
    7. Turn the device on again and check if it connects to the ROGUE AP (it should not).

- Test WP3-Enterprise by means of [`test_e_rogue_wpa3.sh`](Src/test_e_rogue_wpa3.sh)

    1. Prepare the client Network Profile and install the root certificate (`ca.pem`).
    2. Set up the REAL AP and AS.
    3. Check if the device joins the network (it should).
    4. The REAL AP is setdown and a ROGUE AP (and a ROGUE AS) with WPA2 is created.
    5. Check if the device connects to the ROGUE network (it should not).

- Test WPA3-Enterprise UOSC by means of [`test_e_uosc_wpa3.sh`](Src/test_e_uosc_wpa3.sh).

    1. Do not configure the client Network Profile and do not install the root certificate (`ca.pem`).
    2. Set up the REAL AP and AS. The certificates do not include TOD Policies.
    3. Check it the device automatically joins the network. If not, control if it prompts any pop-up message asking the user to trust the server certificate (it should ask).
    4. The REAL AP is setdown and a ROGUE AP (and AS) with WPA3 is created.
    5. Check if the device connects to the ROGUE network. If not, verify that the supplicant prompts any warning message or UOSC request (it shouldi ask).

- Test WPA3-Enterprise TOD by means of [`test_e_tofu_wpa3.sh`](Src/test_e_tofu_wpa3.sh).
    In this case, the examination is geared towards the Trust Override Disable Policies of the supplicant.
    In particular, TOD-TOFU policy is enforced by means of the server certificate (`server.pem`).

    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`).
    2. Set up the REAL AP and AS. The certificates do include the TOD TOFU Policy from WPA3
    3. Check it the device automatically joins the network. If not, control if it prompts any pop-up message asking the user to trust the server certificate (it should ask).
    4. The REAL AP is setdown and a ROGUE AP (and AS) with WPA3 is created.
    5. Check if the device connects to the ROGUE network. If not, verify that the supplicant has inhibited UOSC. The system shall not enquire to trust the new certificate from the rogue AP.
    6. If the supplicant does not connect, turn the device off.
    7. Turn the device on again and check if it connects to the ROGUE AP (it should not).

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
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___OK___
        - By selecting `update=1` in the configuration, the supplicant resists the attack even after its reboot.
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___OK___
        - By selecting `update=1` in the configuration, the supplicant resists the attack even after its reboot.
            In particular, the resulting configuration presents `sae_pk=1` (SAE-PK only mode) from `sae_pk=0` (SAE-PK in automatic mode)
            Unfortunately if Automatic mode is selected, as defined into the standard, if the first network encountered is a FAKE SAE-PK one, the supplicant connects.

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
    - [x] Test WPA3-Enterprise: ___OK___
    - [x] Test WPA3-Enterprise UOSC: ___oo___
        - Neither `wpa_cli` nor `wpa_gui` implement UOSC. If a root certificate is specified, they just trust the one recieved from the server without asking anything to the user.
        	And what if `update=1` and a root ca cert is defined?
    - [x] Test WPA3-Enterprise TOFU: ___oo___
        - The supplicant prints that it gots a certificate with TOD=2 Policy, but still connects to the rogue AP.

### Cypress Board CYW954907AEVAL1F

- Personal

    - [x] Test WPA3-Personal: ___OK___
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___oo___
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___oo___

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
        - Cannot remove certificate. Even though `test.console` should allow not to use it.
    - [x] Test WPA3-Enterprise: ___~~___
        - Cannot select WPA3 from `test.console`. This is because WPA3 is not supported by WDD. However, by selecting WPA2-Enterprise, the board connects with MFP set as required and EAP-SHA256.
    - [x] Test WPA3-Enterprise UOSC: ___oo___
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___

### Keystudio ESP32 Core Board

- Personal

    - [x] Test WPA3-Personal: ___OK___
    - [x] Test WPA3-Personal SAE-PK: ___OK___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___!!___
        - By selecting `[x] Transition disable` via `menuconfig`, the supplicant resists the attack.
            However, after the reboot it forgets about the recieved Transition disable information and joins the rogue network.
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___!!___
        - If the device is configured with SAE-PK Automatic mode, then it joins the rogue AP also after having recieved the Transition disable for SAE-PK -> SAE.
            Moreover, Automatic mode is the default behaviour for the example `station` provided by Espressif.
            The menuconfig does indeed allow to enable SAE-PK, but not to select the mode (and the default one is Automatic mode).

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
        - Using the modified `wifi_enterprise` script revealed that if no certificate is provided, actually the supplicant do not apply a TOFU policy,
            thus it does not trust only the first certificate recieved, but also all the successive ones.
            The user needs to write all the functions to achieve this goal.
    - [x] Test WPA3-Enterprise: ___OK___
        - The example provided by Espressif seems to be bugged: it sets PMF as required just if WPA3-Enterprise 192bit is selected.
            The tests reveals that if this program is used with a WPA3-Enterprise profile, it is possible to make it join a WPA2-Enterprise network
            (at the contrary of what the standard states).
            The fixed program instead works properly.
    - [x] Test WPA3-Enterprise UOSC: ___oo___
        - There is no user interaction for the default program. However, The `wifi_enterprise` example is quite coherent to the WPA3 Standard.
            Indeed, if WPA2 is selected, the user is free to skip the server certificate validation by means of a checkbox; if WPA3 is selected, this option is not available anymore.
            Another interesting feature is that it is not allowed to select weak EAP methods for the external authentication (just TLS, TTLS and PEAP).
            However, the inner protocol cannot be chosen.
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___.
        - Using the modified `wifi_enterprise` program revealed that, if no certificate is provided from the beginning,
            then also a TOD TOFU Policy certificate received from the server do not prevents the supplicant from joining successive roue networks.

### Raspberry Pi 4 wpa_supplicant and NM GUI

- Personal

    - [x] Test WPA3-Personal: ___oo___
        - There is an option in the network configuration window to select WPA3 Personal.
            However, even if selecting it, the Raspberry does not connect.
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___oo___
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___oo___

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
    - [x] Test WPA3-Enterprise: ___~~___
        - Set WPA2 enterprise in the Network profile.
    - [x] Test WPA3-Enterprise UOSC: ___oo___
        - Set WPA2 enterprise in the Network profile.
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___
        - Set WPA2 enterprise in the Network profile.

### Raspberry Pi 4 wpa_supplicant and NM CLI

- Personal

    - [x] Test WPA3-Personal: ___oo___
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___oo___
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___oo___

- Enterprise

    - [x] Test WPA2-Enterprise: ___OK___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
    - [x] Test WPA3-Enterprise: ___~~___
        - Cannot force PMF as required
        - Cannot set EAP-SHA256, only general WPA-EAP.
    - [x] Test WPA3-Enterprise UOSC: ___oo___
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___

#### Steps to use nmcli

1. Remove all the saved network profiles from the NM GUI.

2. Create a new network profile with the GUI, setting all the possible parameters (eq, no PMF).

3. Open the CLI interactive tool:
    ```
    nmcli connection edit name_of_the_network_profile
    ```

3. Get a list of all the possible parameters:
    ```
    print
    ```

4. Disable autoconnection feature:
    ```
    set connection.autoconnect no
    ```

5. Set the remaining ones, like PMF:

6. Save the profile:
    ```
    save
    ```

7. Test the connection:
    ```
    activate wlan0
    ```

### Raspberry Pi 4 iwd and NM GUI

- Personal

    - [x] Test WPA3-Personal: ___OK___
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___!!___
        - If iwd is used as a backend for NetworkManager, then the Transition disable support is inexistent:
            - If the network profile is set as WPA/WPA2/WPA3, then transition disable does not work and the supplicant automatically joins the downgraded network.
            - If the network profile is set as WPA3, then the supplicant does not join the downgraded network by default, but no warning is printed on the screen.
                After that, if the user click again on the SSID from the Network Manager GUI Applet,
                a new network profile is created and the supplicant joins the downgraded network.

    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___oo___

- Enterprise

    - [x] Test WPA2-Enterprise: ___oo___
        - Error from NM that says it is not possible to configure the 802.1X profile for iwd.
    - [x] Test WPA2-Enterprise TOFU: ___oo___
    - [x] Test WPA3-Enterprise: ___oo___
    - [x] Test WPA3-Enterprise UOSC: ___oo___
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___

### Raspberry Pi 4 iwd and NM CLI

- Personal

    - [x] Test WPA3-Personal: ___OK___
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___oo___
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___oo___

- Enterprise

    - [x] Test WPA2-Enterprise: ___oo___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
    - [x] Test WPA3-Enterprise: ___oo___
        - Set WPA2 enterprise in the Network profile.
    - [x] Test WPA3-Enterprise UOSC: ___oo___
        - Set WPA2 enterprise in the Network profile.
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___
        - Set WPA2 enterprise in the Network profile.

### Raspberry Pi Pico W

- Personal

    - [x] Test WPA3-Personal: ___oo___
    - [x] Test WPA3-Personal SAE-PK: ___oo___
    - [x] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2: ___oo___
    - [x] Test WPA3-Personal SAE-PK and Transition Disable SAE-PK -> SAE: ___oo___

- Enterprise

    - [x] Test WPA2-Enterprise: ___oo___
    - [x] Test WPA2-Enterprise TOFU: ___oo___
    - [x] Test WPA3-Enterprise: ___oo___
    - [x] Test WPA3-Enterprise UOSC: ___oo___
    - [x] Test WPA3-Enterprise TOD Mechanism: ___oo___
