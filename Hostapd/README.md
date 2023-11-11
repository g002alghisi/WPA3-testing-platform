# Hostapd Access Point
Creating an Acces Point with bridge on Ubuntu.

## Basic idea
The basic idea is to use `hostapd` to transform the PC into an acces point (AP).
In particular, the PC shall be equipped with:
- an ethernet card, connected to a wired network with a DHCP server;
- a wireless card, that supports AP mode and SAE.
> To verify that the wireless card supports AP mode, inspect the result of
> ```bash
> iw list | grep -C10 "Supported interface modes:"
> ```

Both the interfaces are needed: `hostapd` is used to create an AP, and by means of `brctl` (from `bridge-utils` package) the traffic is forwarded to the ethernet LAN. In this way, it is not needed to configure the DHCP server on the PC.<br>
In case of lacking an ethernet interface card, it should be possible to install a DHCP server on the computer directly, but this option has not been analyzed.

To deal with everything, the `ap.sh` bash script has been created: it allows to safely launch `hostapd` by automatically de-connecting from the WiFi, and it creates the bridge towards the Ethernet LAN.

## Few words about the Hostapd version...
The specific version of `hostapd` is the 2.10, and it has been directly built from the source code that can be found on the Ubuntu repository. This is required because using the program obtained by doing `sudo apt install hostapd` doesn't properly support WPA3 with SAE-PK (instead, bare WPA3). Additional information can be found in the [README](Src/README.md) file in the `Build/` folder. 

## WPA2 and WPA3
To setup wireless LANs with different security protocol, different `.conf` files for `hostapd` have been created. In particular, `ap.sh` allows to directly select the specific secuirty protocol, based on which the proper `.conf` file is used.

The configuration files have been created based on the template that can be found at `/usr/share/doc/hostapd/examples/hostapd.conf` (Ubuntu).

In order to work with WPA3 SAE-PK, a special PSK is required. To do it, the original script `sae_pk_gen` is used. This can be found in the `hostapd` repository, but should be compiled from scratch following the tutorial at [https://github.com/vanhoefm/hostap-wpa3](https://github.com/vanhoefm/hostap-wpa3).
