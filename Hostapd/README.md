# Hostapd Access Point
Creating an Acces Point with bridge on Ubuntu.

### Basic idea
The basic idea is to use `hostapd` to transform my PC into an acces point (AP).
In particular, the PC is equipped with:
+ network controller: Qualcomm Atheros QCA9377 802.11ac Wireless Network Adapter (rev 31);
+ ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 12).

These should be both used: `hostapd` is used to create an AP, and by means of `brctl` (from `bridge-utils` package) the traffic is forwarded to the ethernet LAN. In this way, it is not needed to configure the DHCP server on the PC.

The specific version of `hostapd` is the 2.10, and it has been directly built from the source code that can be found on the Ubuntu repository. This is required because using the program obtained by doing `sudo apt install hostapd` doesn't properly support WPA3 with SAE-PK. More information can be found in the [README](Src/README.md) file in the `Build/` folder. 

Currently, the `ap.sh` bash script allows to safely launch `hostapd` by automatically de-connecting from the WiFi; moreover, it creates the bridge towards the Ethernet LAN.

~The hostapd.conf configuration file has been set to turn on an 802.11ac AP with Automatic Channel Selection (ACS), performed by the driver of the Wireless NIC.~ <br>
The `hostapd.conf` configuration files have been written to setup an 802.11g AP, operating on the channel 1. The reason behind this choice is that it allows to have the broadest compatibility with various types of devices.

### WPA2 and WPA3
To setup wireless LANs with different security protocol, different `.conf` files for `hostapd` have been created. In particular, ap.sh allows to directly select the specific secuirty protocol, based on which the proper .conf file is used.

The configuration files have been created based on the template that can be found at `/usr/share/doc/hostapd/examples/hostapd.conf` (Ubuntu).

In order to work with WPA3 SAE-PK, a special PSK is required. To do it, the original script `sae_pk_gen` is used. This can be found in the `hostapd` repository and compiled from the code following the tutorial at [https://github.com/vanhoefm/hostap-wpa3](https://github.com/vanhoefm/hostap-wpa3).
