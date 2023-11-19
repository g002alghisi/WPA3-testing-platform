# Configuration folder
In this folder, all the `.conf` files for `hostapd` are stored.
These have been created based on the template that can be found at `/usr/share/doc/hostapd/examples/hostapd.conf` (Ubuntu).

Several sub-folders have been created in order to be more organised:
- `Skeleton/` contains bare configuration files that can be used to create personal solutions.
- `Ko/` contains solutions developed personally.
- 'Minimal/' contains a revision of 'Ko/' files extrimely shrinked and for which APs have all the same name
    (usefull to make tests with evil-twins).
- `Basic/` contains configurations copied from Mathy Vanhoef (these are minimal working configurations, but are not well commented).

## General settings
~The `.conf` configuration files from `Ko/` and `Basic/` have been set to turn on an 802.11ac AP with Automatic Channel Selection (ACS), performed by the driver of the Wireless NIC.~

The `.conf` configuration files from `Ko/` and `Basic/` have been written to setup an 802.11g AP, operating on the channel 1. The reason behind this choice is that it allows to have the broadest compatibility with various types of devices.
