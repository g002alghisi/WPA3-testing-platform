# Configuration folder

1. [Introduction](#introduction)
2. [Organization of configuration files](#organization-of-configuration-files)
3. [Switching between different configurations](#switching-between-different-configurations)
4. [General settings](#general-settings)

## Introduction

In this folder, all the `.conf` files for `hostapd` are stored.
These have been created based on the template that can be found at `/usr/share/doc/hostapd/examples/hostapd.conf` (Ubuntu).

## Organization of configuration files

Several sub-folders store `.conf` files with the goal to be more organised:

- `Skeleton/` contains bare configuration files that can be used to create personal solutions.
- `Ko/` contains solutions developed personally.
- `Minimal/` contains a revision of `Ko/` files extrimely shrinked down and for which all APs have the same name (usefull to make tests with evil-twins).

## Switching between different configurations

As explained in [this section](../../Utils/README.md#getting-file-from-conf_listtxt), to make it as seamless as possible to switch between different `hostapd` configuration, `ap_ui.sh` harnesses the file `conf_list.txt` here located by means of the `get_from_list()` function, from `general_utils.sh` module.
To better understand the reasoning behind this approach, please read the `Utils/` [ERADME](../../Utils/README.md) file.

## General settings

The `.conf` configuration files from `Ko/` and `Basic/` have been written to setup an 802.11g AP, operating on the channel 1. The reason behind this choice is that it allows to have the broadest compatibility with various types of devices.
