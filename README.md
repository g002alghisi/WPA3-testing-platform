# Hostap-test
Repo used to make tests with hostapd.

### Basic idea
The basic idea is to use hostapd to transform my PC into an acces point (AP).
In particular, the PC is equipped with:
+ network controller: Qualcomm Atheros QCA9377 802.11ac Wireless Network Adapter (rev 31);
+ ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 12).
These should be both used: the hostapd is used to create an  AP, but by means of bridge-utils (in particular, brctl) the traffic has to be forwarded to the ethernet LAN. in this way, it is not need to configure the DHCP server on the PC.

Currently, the run_hostapd.sh bash script allows to safely launch hostapd by automatically de-connecting from the WiFi.
The hostapd.conf configuration file has been set to turn on an 802.11ac AP with Automatic Channel Selection (ACS), performed by the driver of the Wireless NIC.

### Configuration file
The configuratio file hostapd.conf has been created from the one that can be found at  /usr/share/doc/hostapd/examples/hostapd.conf.
This file has been copied (for reasons of ease) to original_hostapd.conf.
