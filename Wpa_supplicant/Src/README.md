# Supplicant Station with `sta.sh`
This script allows you to seamlessly setup an supplicant Station to join a WiFi network.

In general, `wpa_supplicant` requires `.conf` files to be, as the extension suggests, configured. These can be found in the `Conf/` folder.

### Usage
The script handles few inputs:
- the `-w wifi_if` optional parameter to specify the wireless interface, if different from the default one specified inside the code.
- a string to select the desired `.conf` file; indeed, to achieve more flexibility, at the beginning of the program is possible to specifie different configuration files. in the main section, the input of the user are handled, and by means of a switch-case structure, the proper `.conf` file is selected in accordance.

An example of use is the following:
```bash
./sta.sh -w wlan0 wpa3-pk
```
