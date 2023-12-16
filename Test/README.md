# Test Modalities and Results

1. [Devices](#devices)
2. [Tests](#tests)
3. [Results](#results)

## Devices

- Cypress Board CYW954907AEVAL1F, Wi-Fi module based on CYW54907 device.
- Keystudio ESP32 Core Board, with ESP32-WROOM-32 and Espressif IDF v5.1.1.
- Raspberry Pi 4, [add informations about version].
- iPad Air 2022, iPadOS 17.1.2.
- POCO F3, Android 13 TKQ1.220829.002, MIUI Global 14.0.9.
- Ubuntu Desktop 23.10.1, running on a Virtual Machine (VirtualBOX) and set up USB passthrough for the TP-Link Archer T2U v3 Wi-Fi dongle.
- Windows 11, running on a Virtual Machine (VirtualBOX) and set up USB passthrough for the TP-Link Archer T2U v3 Wi-Fi dongle.
- TP-Link Archer T2U v3 Wi-Fi dongle, chipset RTL8811AU, driver: [morrownr 8821au](https://github.com/morrownr/8821au-20210708) for Linux, [official](https://www.tp-link.com/it/support/download/archer-t2u/) for Windows.

## Tests

### Personal

- [Test WPA3-Personal](Src/test_p_wpa3.sh). Create a WPA3 network and check if devices are able to connect. Allow both PWE methods (Hunting-and-Pecking and Hash-to-curve).

- [Test WPA3-Personal SAE-PK](Src/test_p_wpa3_pk.sh). Create a WPA3 network with SAE-PK and verify which devices are already support it. Threaten it to join a rogue WPA3 network.

- [Test WPA2/3-Personal and transition disable WPA3 -> WPA2](Src/test_p_wpa2_wpa3.sh).

    1. Set up the real AP with WPA2/3 and Transition Disable WPA3 -> WPA2 enabled.
    2. The device joins the network.
    3. The real AP is setdown and a rogue AP with just WPA2 is created.
    4. Check if the device connets to the rogue network.

- [Test WPA3-Personal SAE-PK and Transition disable SAE-PK -> SAE](Src/test_p_wpa3_pk.sh).

    1. Set up the real AP with WPA3, SAE-PK and Transition Disable SAE-PK -> SAE enabled.
    2. Select `Automatic Mode` for SAE-PK on the supplicant device.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP with just SAE (not SAE-PK) is created.
    5. Check if the device connets to the rogue network.

### Enterprise

- [Test WPA2-Enterprise](Src/test_e_wpa2.sh). Verify if the device distrusts fake server certificates.

    1. Always prepare the client Network Profile and install the root certificate (`ca.pem`). 
    2. Set up the real AP and AS.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and a rogue AS) with WPA2 is created.
    5. Check if the device connets to the rogue network.

- [Test WPA3-Enterprise UOSC](Src/test_e_wpa3.sh). Set up a WPA3-Enterprise protected AP, thus that announces PMF as required.

    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`). 
    2. Set up the AP and AS.
    3. Check it the device automatically joins the network. If not, control if prompts any pop-up message asking the user to trust the server certificate.

- [Test WPA3-Enterprise TOD](Src/test_e_wpa3.sh). In this case, the examination is geared towards the Trust Override Disable Policies of the supplicant. In particular, TOD-TOFU policy is enforced by means of the server certificate (`server.pem`).
    
    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`). 
    2. Set up the real AP. The AS 
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and AS) with WPA3 is created.
    5. Check if the device connets to the rogue network. If not, verify that the supplicant has inhibited UOSC. The system shall not enquire to trust the new certificate from the rogue AP.

## Results

### Template

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### Cypress Board CYW954907AEVAL1F

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### Keystudio ESP32 Core Board

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### Raspberry Pi 4

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### iPad Air 2022, iPadOS 17.1.2

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### POCO F3

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

###  Ubuntu Desktop 23.10.1

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

### Windows 11

- Personal

    - [ ] Test WPA3-Personal
    - [ ] Test WPA3-Personal SAE-PK
    - [ ] Test WPA2/3-Personal and Transition Disable WPA3 -> WPA2
    - [ ] Test WPA3-Personal SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2-Enterprise
    - [ ] Test WPA3-Enterprise UOSC
    - [ ] Test WPA3-Enterprise TOD Mechanism

