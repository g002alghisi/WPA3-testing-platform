# Sniff the traffic with sniff.sh
The bash script `sniff.sh` can be used to start wireshark in a controlled way. Indeed, it is required to put the wireless card in monitor mode.
Thus, `sniff.sh`has been creared to carry out all the necessary steps to set the interface up and, once finished, set everything down.

It has to be highlighted that the script shall be modified based on the specific wireless interface used. Indeed, each chipset/driver
has a specific way to be set for this goal. This version of the program can be used with the TP-Link Archer T2U V3.
