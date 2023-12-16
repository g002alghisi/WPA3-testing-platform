# My Project Hostapd-test

## Tests

### ESP32

- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (OK)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (!!) [not implemented Transition Dsable SAE-PK -> SAE]

Discussed with Espressif technicals, and they said that Transition disable for SAE-PK is not a priority (not mandatory, they already knew about the "bug")

- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [?] Test with TOD [still to figure out how this test can be implemented, considering the fact that the user interact by CLI and you do not get popups like on GUI]

### Cypress board

- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (--) [WPA3 R3 not supported]
- [x] Test with WPA2/3 and transition disable (--) [WPA3 R3 not supported]
- [x] Test with SAE-PK and transition disable (--) [WPA3 R3 not supported]

Posted the question about SAE-PK and Transition Disable on the formum. Got a replay explaining that the board do not support WPA3 R3. Consequently, SAE-PK and Transition Disable are currently unavailable (refer to [Infineon community forum](https://community.infineon.com/t5/AIROC-Wi-Fi-MCUs/CYW54907-with-SAE-PK-and-or-Transition-Disable/td-p/642416)).

- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

### Raspberry Pi 4

- [x] Test with WPA3 (!!) [do not support WPA3]
- [x] Test with WPA2/3 and transition disable (--) [Do not support WPA3]
- [x] Test with SAE-PK (--) [do not support WPA3]
- [x] Test with SAE-PK and transition disable (--) [do not support WPA3]
- [x] Test with WPA2 and MFP set as required (OK) [to be chacked again...]
- [x] Test with `iwd` (--) [set it up, but stil do not connect to WPA3]

Unfortunately, the Raspberry Pi 4 (and olders) doesn't support WPA3 out-of-the-box.
This is due to problems related the Broadcom wireless module driver, and can be fixed in two ways:

- Patch the firmware/kernel with Cypress patches, but this solution can be very tedious for non-technical users.
- Make the system use `iwd` instead of `wpa_supplicant`, but the same, it can be complicated and it is not so scalable... (tried, but it doesn't work...)

- [ ] Test with WPA2-Enterprise
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

### Wpa-supplicant

- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (OK)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (OK)

- [ ] Test with WPA2-Enterprise
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

### POCO F3

- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (!!)
- [x] Test with SAE-PK and transition disable (--)

The implementation of transition disable mechanism is plagued with flaws. The upcoming test has been conducted:

1. First, a real AP is setup.
2. Then the devices joins the WPA2-WPA3 network. The AP announces by means of Transition Disable that all the AP of the network support WPA3.
3. Afer that, the real AP is setdown and a rogue AP with just WPA2 is created.
4. Finally, make the device try to connect to the rogue Network, succesfully and without waiting for user interaction.

This is the minor concern, considering the fact that this device do not validate server certificates with WPA-Enterprise...

- [x] Test with WPA2-Enterprise (!!) [susceptible to evil-twins attacks]
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

The results from WPA-Enterprise tests are catastrofic... The upcoming test has been conducted:

1. Initialize the network profile for the Wi-Fi network.
2. Set up the real AP with WPA2-Enterprise.
3. Try to connect.
4. Turn of the real AP and set up the rogue AP.
5. Try to connect to the rogue AP. It connects...

This is a very poor and dangerous implementation of the supplicant program.

### iPad

- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (~~)
- [x] Test with SAE-PK and transition disable (--)

The device behaves better than POCO F3 phone with respect transition disable. The upcoming test has been conducted:

1. First, a real AP is setup.
2. Then the devices joins the WPA2-WPA3 network. The AP announces by means of Transition Disable that all the AP of the network support WPA3.
3. Afer that, the real AP is setdown and a rogue AP with just WPA2 is created.
4. Finally, make the device try to connect to the rogue Network.

The iPad, at the countrary of the POCO F3, refuses to join the network and says that the password is not correct. Also by retyping the password, it refuses to connect.
Moreover, the ssid disappears from the list of availables ones.
At this time, by setting up again the real AP, the tablet connects again without asking for the password again.

- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

### Ubuntu (out-of-the-box)

- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (..)
- [x] Test with SAE-PK and transition disable (--)

- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

### Windows 11

- [x] Test with WPA3 (!!)
- [ ] Test with SAE-PK
- [ ] Test with WPA2/3 and transition disable
- [ ] Test with SAE-PK and transition disable

- [x] Test with WPA2-Enterprise (OK)
- [x] Test with WPA3-Enterprise (OK)
- [x] Test with TOD-TOFU (OK)

Unfortunately Windows 11, tested in virtual machine with the TP-Link dongle, does not work with WPA3. The problem is likely related to the TP-Link driver that does not fully support SAE.
Indeed, WPA3-Enterprise, that do not leverage SAE, works nicely.

W11 correctly implement TOD mechanism. At the moment, only TOS-TOFU policy implementation have been evaluated as follows:

- First, trials with WPA2-Enterprise and rogue AP have been made:

    1. Do not initialize any network profile for the Wi-Fi network.
    2. Set up the real AP with WPA2-Enterprise.
    3. Try to connect with the W11 PC and trust the server certificate recieved.
    4. Turn of the real AP and set up the rogue AP.
    5. Try to connect to the rogue AP. W11 prompt a pop-up windows warning the user that something's wrong and asking to trust the new certificate.

    This behaviour is actually coherent with the new WPA3 Server Certificate Validation feature and UOSC (in this case no TOD Policies are enforced).

- Then, tests with focus on WPA3-Enterprise with TOD-TOFU Policy have been carried out:

    1. Do not initializing any network profile for the Wi-Fi network.
    2. Set up the real AP with WPA3-Enterprise and server certificate with TOD-TOFU OID.
    3. Try to connect with the W11 PC and trust the server certificate recieved.
    4. Turn of the real AP and set up the rogue AP.
    5. Try to connect to the rogue AP. W11 prompt a pop-up window warning the user that something's wrong, but this time not asking to trust the new certificate.

## TP-Link Archer T2U

To use the Wi-Fi donge it is necessary to install the drivers.

In general, one can follow the official guide. However, in Linux few errors arose.
The Morrowr's driver comes in hand; please visit the GitHub repo at [https://github.com/morrownr/8821au-20210708](https://github.com/morrownr/8821au-20210708) for more information.

### Other useful links

- [https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility](https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility)
- [https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3](https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3)
- [https://github.com/morrownr/Monitor_Mode](https://github.com/morrownr/Monitor_Mode)

## Other devices

### TP-Link

- TP-Link devices that support WPA3 are showed [here](https://www.tp-link.com/ae/wpa3/product-list/).

### Cypress/Infineon

- PSoC6 with CYW43439 should support WPA3 R3 (got a reply from Infineon)

    - [Board page](https://www.infineon.com/cms/en/product/evaluation-boards/cy8cproto-062s2-43439/)
    - [CYW43439 page](https://www.infineon.com/cms/en/product/wireless-connectivity/airoc-wi-fi-plus-bluetooth-combos/wi-fi-4-802.11n/cyw43439/)
    - [This PDF](https://www.infineon.com/dgdl/Infineon-Wireless_Module_Partners_Selector_Guide-ProductSelectionGuide-v02_00-EN.pdf?fileId=8ac78c8c82ce56640183184a05d72e5a) just says that it support WPA3, but it does not specify if WPA3-R3.
    - [This PDF](https://www.infineon.com/dgdl/Infineon-CYW43439-DataSheet-v05_00-EN.pdf?fileId=8ac78c8c8929aa4d01893ee30e391f7a), again, says that it support WPA3, but do not specify WPA3 R3.
    - 

- The PSoC 6 WiFi-BT Pioneer Kit (CY8CKIT-062-WiFi-BT) is a low-cost hardware platform that enables design and debug of the PSoC™ 62 MCU and the Murata LBEE5KL1DX Module (CYW4343W WiFi + Bluetooth Combo Chip).
    Visit:

## Raspberry Pi 4
This folder contains information about the Wi-Fi related tests made with a Raspberry Pi 4 board, equipped with Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux.

    - [the home page](https://www.infineon.com/cms/en/product/evaluation-boards/cy8ckit-062-wifi-bt/);
    - [the CYW4343W page](https://www.infineon.com/cms/en/product/wireless-connectivity/airoc-wi-fi-plus-bluetooth-combos/wi-fi-4-802.11n/cyw4343w/); here they state that it supports WPA2;
    - [this pdf](https://www.infineon.com/dgdl/Infineon-CYW4343W_Single-chip_ultra-low_power_IEEE_802.11b_g_nMAC_baseband_radio_with_integrated_Bluetooth_4.2_for_IoT_applications-ProductBrief-v03_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0f6643ff542e) claims that it supports WPA3;
    - reading [here](https://iotexpert.com/category/devkits/cy8ckit-062-wifi-bt/) it seems that WPA3 works, but not WPA3-R3;

### Raspberry

- [The Pi Pico W page](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html) says that it uses the same Wi-Fi module, but using the `libwyc43` library; [here](https://github.com/georgerobotics/cyw43-driver/tree/195dfcc10bb6f379e3dea45147590db2203d3c7b/src) the source code is available; inspecting it, WPA3 support has not been found;
- [This article](https://rachelbythebay.com/w/2023/11/06/wpa3/) states that probably the Pi 5 board still doesn't support WPA3.

## Idea nuovo protocollo WPA-Enterprise

### Double Key Authentication
    
