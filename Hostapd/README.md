# Hostapd Access Point
Creating an Acces Point with bridge on Ubuntu.

## Basic idea
The basic idea is to use `hostapd` to transform the PC into an acces point (AP).
In particular, the PC shall be equipped with:
- an ethernet card, connected to a wired network with a DHCP server;
- a wireless card, that supports AP mode.
> To verify that the wireless card supports AP mode, inspect the result of
> ```bash
> iw list
> ```
> and look for `"Supported interface modes"` section. It should be there specified if the AP mode is supported or not.

Both the interfaces are needed: `hostapd` is used to create an AP by using the wireless card, and by means of `brctl` (from `bridge-utils` package) the traffic is forwarded to the wired LAN passing through the ethernet card. In this way, it is not needed to configure the DHCP server on the PC.<br>
In case the PC lacks the ethernet interface card, it should be possible to install a DHCP server on the computer directly, but this option has not been analyzed.

To deal with everything, the `ap.sh` bash script has been created: it allows to safely launch `hostapd` by checking the physical interfaces state, creating the bridge towards the ethernet LAN, stopping system services that could interfere with the process (like NetworkManager), running `hostapd`, and finally (almost completely) restoring the initial state of the system.

## Few words about the Hostapd version...
The specific version of `hostapd` is the 2.10, and it has been directly built from the source code that can be found on the Ubuntu repository. This is required because the same version of the program obtained by doing `sudo apt install hostapd` doesn't properly support WPA3 with SAE-PK (instead, bare WPA3). Additional information can be found in the [README](Src/README.md) file in the `Build/` folder. 

## Access Point configuration
To setup wireless LANs with different security protocol, different `.conf` files for `hostapd` have been created. In particular, `ap.sh` allows to directly select the desired `.conf` file (between the ones specified in the code directly) by means of a string parameter.

In order to work with WPA3 SAE-PK, a special PSK is required. To do it, the original script `sae_pk_gen` is used. This can be found in the `hostapd` repository, but should be compiled from scratch following the tutorial at [https://github.com/vanhoefm/hostap-wpa3](https://github.com/vanhoefm/hostap-wpa3).
