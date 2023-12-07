# Test Modalities and Results

1. [Devices](#devices)
2. [Tests](#tests)
3. [Results](#results)

## Devices

- iPad Air 2022, iPadOS 17.1.2.
- POCO F3, Android 13 TKQ1.220829.002, MIUI Global 14.0.9.
- Ubuntu Desktop 23.10.1, running on a Virtual Machine in VirtualBOX [add dongle and driver information].
- Windows 11, running on a Virtual Machine in VirtualBOX [add dongle and driver information].
- Cypress Board CYW954907AEVAL1F, Wi-Fi module based on CYW54907 device.
- Keystudio ESP32 Core Board, with ESP32-WROOM-32 and Espressif IDF v5.1.1.
- Raspverry Pi 4, [addi informations about version].

[Give information about TP-Link dongle]

## Tests

### Personal [map each test to a bash script from Src/ folder]

- Test WPA3. Create a WPA3 network and check if devices are able to connect.
    Allows both PWE methods (Hunting-and-Pecking and Hash-to-curve).

- Test SAE-PK. Create a WPA3 network with SAE-PK and verify which devices are already support it. Threaten it to join a rogue WPA3 network.

- Test WPA2/3 and transition disable WPA3 -> WPA2.

    1. Set up the real AP with WPA2/3 and Transition Disable WPA3 -> WPA2 enabled.
    2. The device joins the network.
    3. The real AP is setdown and a rogue AP with just WPA2 is created.
    4. Check if the device connets to the rogue network.

- Test SAE-PK and Transition disable SAE-PK -> SAE.

    1. Set up the real AP with WPA3, SAE-PK and Transition Disable SAE-PK -> SAE enabled.
    2. Select `Automatic Mode` for SAE-PK on the supplicant device.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP with just SAE (not SAE-PK) is created.
    5. Check if the device connets to the rogue network.

- [ ] Test WPA3
- [ ] Test SAE-PK
- [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
- [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

### Enterprise

- Test WPA2-Enterprise. Verify if the device distrusts fake server certificates.

    1. Always prepare the client Network Profile and install the root certificate (`ca.pem`). 
    2. Set up the real AP and AS.
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and a rogue AS) with WPA2 is created.
    5. Check if the device connets to the rogue network.

- Test WPA3-Enterprise UOSC. Set up a WPA3-Enterprise protected AP, thus that announces PMF as required.

    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`). 
    2. Set up the AP and AS.
    3. Check it the device automatically joins the network. If not, control if prompts any pop-up message asking the user to trust the server certificate.

- Test TOD mechanism. In this case, the examination is geared towards the Trust Override Disable Policies of the supplicant. In particular, TOD-TOFU policy is enforced by means of the server certificate (`server.pem`).
    
    1. Do not edit the client Network Profile and do not install the root certificate (`ca.pem`). 
    2. Set up the real AP. The AS 
    3. The device joins the network.
    4. The real AP is setdown and a rogue AP (and AS) with WPA3 is created.
    5. Check if the device connets to the rogue network. If not, verify that the supplicant has inhibited UOSC. The system shall not enquire to trust the new certificate from the rogue AP.

## Results

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### POCO F3

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### Ubuntu Desktop 23.10.1

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### Windows 11 [add version]

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### Cypress Board CYW954907AEVAL1F

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

###  Keystudio ESP32 Core Board, with ESP32-WROOM-32 and Espressif IDF v5.1.1.

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### Raspverry Pi 4 [addi informations about version]

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

### iPad Air 2022

- Personal

    - [ ] Test WPA3
    - [ ] Test SAE-PK
    - [ ] Test WPA2/3 and Transition Disable WPA3 -> WPA2
    - [ ] Test SAE-PK and Trandisition Disable SAE-PK -> SAE

- Enterprise

    - [ ] Test WPA2 
    - [ ] Test WPA3 UOSC
    - [ ] Test TOD Mechanism

