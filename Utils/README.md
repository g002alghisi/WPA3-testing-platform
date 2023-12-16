# Utilities

1. [Introduction](#introduction)
2. [Module list](#module-list)
3. [Getting file from `conf_list.txt`](#getting-file-from-conf_listtxt)

## Introduction
This folder contains "utility libraries" written in bash and mainly used by scripts from `Hostapd/`, `Wpa_supplicant/` and `Freeradius/`, but not only.

## Module list
These modules provides several functions that can be useful in different contexts.
In particular, `Src/` contains four modules:
- `general_utils.sh`, for general functions.
- `net_if_utils`, to handle Ethernet and Wireless interfaces;
- `br_utils`, to deal with bridges;
- `nm_utils`, to start and stop `NetworkManager` service.

Further details about the functions provided by each module will not be presented here, but for `get_from_list()` from `general_utils.sh`. This because most of the scripts of this repository that act as frontend leverage this function, and is interesting to understand the related workflow.

## Getting file from `conf_list.txt`
`hostapd`, `wpa_supplicant` and `freeradius` all make the user configure their behaviour by means of special files (or folder for `freeradius`) that are passed as parameter to them at the launch instant.
The wrappers around them, like `ap.sh`, `sta.sh` and `as.sh`, work in the same way: they want to be given the path that carries to the specific configuration.
To switch between different configuration as seamless as possible, `ap_ui.sh`, `sta_ui.sh` and `as_ui.sh` harnesses special files called `conf_list.txt` and located in their respective `Conf/` folders.

To better understand the reasoning behind this approach, consider the following `conf_list.txt` example, used by `ap_ui.sh` and located in `Hostapd/Conf/`:

```plain text
### ### ### Configuration file list ### ### ###

# Personal
p:wpa2=Hostapd/Conf/Minimal/Personal/p_wpa2.conf
p:wpa3=Hostapd/Conf/Minimal/Personal/p_wpa3.conf
p:wpa2-wpa3=Hostapd/Conf/Minimal/Personal/p_wpa2_wpa3.conf
p:wpa3-pk=Hostapd/Conf/Minimal/Personal/p_wpa3_pk.conf
p:fake-wpa3-pk=Hostapd/Conf/Minimal/Personal/p_fake_wpa3_pk.conf

# Enterprise
e:wpa2=Hostapd/Conf/Ko/Enterprise/e_wpa2.conf
```

The file consists of several lines. The ones that starts with `#` or that are empty are ingored during the parse phase.
These are used to comment the file and make it readable and clean.

The remaining lines all have the same structure:
```plain text
conf_string=conf/file/path
```
Thus, each line is a mapping between `conf_string`, and the path to a configuration file. Please note that the path should be given relatively to the `Hostapd-test` main repository folder. Indeed, to avoid troubles given to inconsistent relative paths, all the programs try to move the present working directory to reach this root folder.

> All the strings presented have the same inner-structure:
> ```plain text
> x:something
> ```
> where `x` is a letter (specifically, `p` or `e`). However, this inner-structure is not considered by the program that parses the list, but helps to distinct between Personal and Enterprise configuration files.

The function `get_from_list()` takes two input parameters: `conf_string` and `path/to/conf_list.txt`;
then it does nothing more than inspecting the given `conf_list.txt` file and retriving the path of the configuration file associated to the specific `conf_string`.