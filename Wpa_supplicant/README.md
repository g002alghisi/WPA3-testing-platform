# Wpa Supplicant Station
Setup a supplicant Station on Ubuntu.

## Basic idea
The basic idea is to use `wpa_supplicant` to transform the PC into a supplicant Station.
The PC shall be equipped with a wireless card.

Similarly to `hostapd`, using `wpa_supplicant` could be not so straight-forward. Indeed, to avoid errors and unexpected behaviours it is important to do preliminary checks about the physical wireless interface, stop all the services that can interfere (like `NetworkManager` or other instances of `wpa_supplicant`, often used by the Operating System to join WiFi networks), and at the end restore the initial state of the system.<br>
To automatically execute all these operations, the `sta.sh` script comes in hand, seamlessly allowing to join wireless networks.

## Few words about the Wpa-Supplicant version...
The specific version of `wpa_supplicant` is the 2.10, and it has been directly built from the source code that can be found on the Ubuntu repository. This is required because the same version of the program obtained by doing `sudo apt install wpasupplicant` doesn't properly support WPA3 with SAE-PK (instead, bare WPA3). Additional information can be found in the [README](Build/README.md) file in the `Build/` folder.

## Work flow
In general, supplicant Stations created with `wpa_supplicant` can be configured by editing special `.conf` files. However, to easily work with different settings, `sta.sh` allows to directly select the desired `.conf` file by means of a string parameter. Each special string maps (by means of its path) a specific `.conf` file, that should be placed in the `Conf/` directory.<br>
In short, this is the work flow to setup the supplicant Station:
1. Prepare the `.conf` setting file and place it in the `Conf/` directory (not mandatory, but recommended).
2. Edit the `sta.sh` to create a new mapping string that points to your `.conf` file.
3. Run `sta.sh` by passing it your mapping string.

The supplicant Station setup with `sta.sh` is mainly used to join wireless networks created with the counterpart `ap.sh`, from the `Hostapd/` folder. For these reason, the `.conf` files stored in the `Conf/` folder are themselves the counterparts of the `hostapd` configuration files from the `Hostapd/Conf/` folder.
