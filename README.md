# My ProjectHostapd-test

## Todo List

### Personal

#### ESP32
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (OK)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (!!)

#### Cypress board
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (--)
- [x] Test with WPA2/3 and transition disable (--)
- [x] Test with SAE-PK and transition disable (--)

#### Raspberry Pi 4
- [x] Test with WPA3 (!!)
- [x] Test with WPA2/3 and transition disable (--)
- [x] Test with SAE-PK (--)
- [x] Test with SAE-PK and transition disable (--)
- [x] Test with MFP set as required (--)
- [x] Test with `iwd` (--)

#### Wpa-supplicant
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (OK)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (OK)

#### POCO F3
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (!!)
- [x] Test with SAE-PK and transition disable (--)

#### iPad
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (OK)
- [x] Test with SAE-PK and transition disable (--)

#### Ubuntu (out-of-the-box)
- [x] Test with WPA3 (OK)
- [x] Test with SAE-PK (!!)
- [x] Test with WPA2/3 and transition disable (..)
- [x] Test with SAE-PK and transition disable (--)


### Enterprise

#### ESP32
- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

#### Cypress board
- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

#### Raspberry Pi 4
- [ ] Test with WPA2-Enterprise
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

#### Wpa-supplicant
- [ ] Test with WPA2-Enterprise
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

#### POCO F3
- [x] Test with WPA2-Enterprise (!!)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

#### iPad
- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD

#### Ubuntu (out-of-the-box)
- [x] Test with WPA2-Enterprise (OK)
- [ ] Test with WPA3-Enterprise
- [ ] Test with TOD


## TP-Link Archer T2U

To use the Wi-Fi donge it is necessary to install the drivers.

In general, one can follow the official guide. However, in Linux few errors arose.
The Morrowr's driver comes in hand; please visit the GitHub repo at [https://github.com/morrownr/8821au-20210708](https://github.com/morrownr/8821au-20210708) for more information.

### Other useful links
- [https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility](https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility)
- [https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3](https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3)
- [https://github.com/morrownr/Monitor_Mode](https://github.com/morrownr/Monitor_Mode)


## Raspberry Pi 4
This folder contains information about the Wi-Fi related tests made with a Raspberry Pi 4 board, equipped with Linux raspberrypi 6.1.0-rpi4-rpi-v8 #1 SMP PREEMPT Debian 1:6.1.54-1+rpt2 (2023-10-05) aarch64 GNU/Linux.


### Wi-Fi test results
Unfortunately, the Raspberry Pi 4 (and olders) doesn't support WPA3 out-of-the-box.
This is due to problems of the Broadcom wireless module driver, and can be fixed in two ways:
- Patch the firmware/kernel with Cypress patches, but this solution can be very tedious for non-technical users.
- Make the system use `iwd` instead of wpa_supplicant, but the same, it can be complicated and it is not so scalable... (tried, but it doesn't work...)
