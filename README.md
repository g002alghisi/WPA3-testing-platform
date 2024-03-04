# WPA3-testing-platform

WPA3-testing-platform is a framework that easily allows to transform a generic GNU/Linux PC equipped with a wireless network card into a full hackable AP that supports the latest WPA3 mechanisms.

This framework is built around two open source programs, Hostapd and FreeRADIUS, that facilitates the creation of both WPA3-Personal and WPA3-Enterprise Wi-Fi networks.

## TP-Link Archer T2U

To use the Wi-Fi donge it is necessary to install the drivers.

In general, one can follow the official guide. However, in Linux few errors arose.
The Morrowr's driver comes in hand; please visit the GitHub repo at [https://github.com/morrownr/8821au-20210708](https://github.com/morrownr/8821au-20210708) for more information.

### Other useful links

- [https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility](https://www.aircrack-ng.org/doku.php?id=compatibility_drivers#compatibility)
- [https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3](https://wikidevi.wi-cat.ru/TP-LINK_Archer_T2U_v3)
- [https://github.com/morrownr/Monitor_Mode](https://github.com/morrownr/Monitor_Mode)

### Persistent USB Tethering Interface name

- Consider [this forum reply](https://unix.stackexchange.com/questions/750214/disable-udev-renaming-for-android-usb-tethering-using-randon-macs) and [this one](https://unix.stackexchange.com/questions/726258/consistent-persistent-network-connection-naming-like-udev) to understand how to make USB Tethering interface name persistent on Ubunut.
