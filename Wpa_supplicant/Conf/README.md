# Configuration folder

1. [Introduction](#introduction)
2. [Organization of configuration files](#organization-of-configuration-files)
3. [Switching between different configurations](#switching-between-different-configurations)
4. [Strange behaviour with WPA3](#strange-behaviour-with-wpa3)

## introduction

In this folder, all the `wpa_supplicant.conf` files are stored.
These have been created based on the template that can be found at `/usr/share/doc/wpasupplicant/examples/wpa_supplicant.conf` (Ubuntu).

## Organization of configuration files

Several sub-folders store `.conf` files with the goal to be more organised:
- `Skeleton/` contains frame configuration files that can be used to create personal solutions.
- `Ko/` contains personal solutions.
- `Minimal/` contains a revision of `Ko/` files extrimely shrinked and for which APs have all the same name
- `Other/` contains special configuration files used to work with `wpa_cli` and `wpa_gui`.

The configuration files stored in `Basic/` and `Ko/` can be used to join networks created with `ap.sh` when `.conf` files from `Hostapd/Ko/` and `Hostapd/Minial/` folders are forwarded to the program.


## Switching between different configurations
As explained in [this section](../../Utils/README.md#getting-file-from-conf_listtxt), to make it as seamless as possible to switch between different `wpa_supplicant` configuration, `sta_ui.sh` harnesses the file `conf_list.txt` here located by means of the `get_from_list()` function, from `general_utils.sh` module.
To better understand the reasoning behind this approach, please read the `Utils/` [ERADME](../../Utils/README.md) file.

## Strange behaviour with WPA3
It has been noticed that when trying to connect to a WPA3 network, the `auth_alg` causes problems. It is enough to comment it and everyithing works fine.
