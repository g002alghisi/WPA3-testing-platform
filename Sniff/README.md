# Sniff wireless traffic with Wireshark

1. [Introduction](#introduction)
2. [Monitor Mode](#monitor-mode)
3. [Bash script: `sniff.sh`](#bash-script-sniffsh)

## Introduction
[Wireshark](https://www.wireshark.org/), an open-source network analysis tool, is crucial for capturing, analyzing, and visualizing network traffic. It provides meticulous packet analysis, protocol decoding, layered visualization based on the OSI model, and detailed network statistics. Wireshark supports customization through filters and plugins, making it a versatile tool for network administrators and analysts globally.


## Monitor Mode
Monitor mode is an operational state for wireless network cards that enables the capturing and analysis of all radio traffic on a specific channel. In this mode, the card can intercept all packets within its coverage area, not limited to those addressed to its own MAC address.

Monitor mode is essential for wireless traffic sniffing, allowing tools like Wireshark to passively capture all packets transmitted on a specific channel. Without this mode, the network card would capture only packets destined for the device, limiting the ability to analyze the entire spectrum of surrounding wireless traffic.

## Workflow

The bash script `sniff.sh` facilitates the controlled initiation of Wireshark in Monitor Mode. It is necessary to put the wireless card in Monitor Mode before starting Wireshark. The script has been created to execute all the essential steps to set the interface up and, upon completion, set everything down.
To make it short, this bash script is designed to facilitate Wireshark usage in Monitor Mode.

Please note that the script needs modification based on the specific wireless interface used, as each chipset/driver has a specific configuration method. The current version of the program is compatible with the TP-Link Archer T2U V3. For more information, visit [this page](https://wiki.wireshark.org/CaptureSetup/WLAN).
