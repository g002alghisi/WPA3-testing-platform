# Access Point with `ap.sh`
This script allows you to seamlessly setup an Access Point by using hostapd.

In general, `hostapd` requires `.conf` files to be, as the extension suggests, configured. These can be found in the `Conf/` folder.

### Usage
The script handles few inputs:
- the `-w wifi_if` optional parameter to specify the wireless interface, if different from the default one specified inside the code.
- the `-e eth_if` optional parameter to specify the ethernet interface, if different from the default one specified inside the code.
- a string to select the desired `.conf` file; indeed, in order to have more flexibility, at the beginning of the program is possible to specifie different configuration files. in the main section, the input of the user are handled, and by means of a switch-case structure, the proper `.conf` file is selected in accordance.

An example of use is the following:
```bash
./ap.sh -w wlan0 -e eth0 wpa3-pk
```
