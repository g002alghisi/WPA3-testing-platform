# Configuration folder
In this folder, all the `.conf` files for `hostapd` are stored.
These have been created based on the template that can be found at `/usr/share/doc/hostapd/examples/hostapd.conf` (Ubuntu).

Several sub-folders have been created in order to be more organised:
- `Skeleton/` contains bare configuration files that can be used to create personal solutions.
- `Ko/` contains solutions developed personally.
- `Minimal/` contains a revision of `Ko/` files extrimely shrinked down and for which all APs have the same name (usefull to make tests with evil-twins).

## Switch between different configurations with `conf_list.txt`
To make it as seamless as possible to switch between different `hostapd` configuration, `ap_ui.sh` harnesses the file `conf_list.txt` here located.
To better understand the reasoning behind this approach, consider the following `conf_list.txt` example:
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
The file consists of several lines. The ones that starts with `#` or are empty are ingored during the parse phase.
These are used to comment the file and make it readable and clean.

The remaining lines have all the same structure:
```plain text
conf_string=conf/file/path
```
Thus, each line is a mapping between `conf_string`, and the path to a configuration file.

All the string presented have the same inner-structure:
```plain text
x:something
```
where `x` is a letter (specifically, `p` or `e`). However, this inner-structure is not considered by the program that parses the list, but helps to distinct between Personal and Enterprise configuration files.


## General settings
The `.conf` configuration files from `Ko/` and `Basic/` have been written to setup an 802.11g AP, operating on the channel 1. The reason behind this choice is that it allows to have the broadest compatibility with various types of devices.
