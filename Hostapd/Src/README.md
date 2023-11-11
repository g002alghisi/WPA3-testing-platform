# Access Point with `ap.sh`
This script allows you to seamlessly setup an Access Point by using `hostapd`.

In general, `hostapd` requires `.conf` files, as the extension suggests, to be configured. These can be found in the `Conf/` folder.

## Usage
The script handles few inputs:
- the `-d` optional parameter to select the verbose mode.
- the `-w wifi_if` optional parameter to specify the wireless interface, if different from the default one specified inside the code.
- the `-e eth_if` optional parameter to specify the ethernet interface, if different from the default one specified inside the code.
- a string to select the desired `.conf` file. Indeed, in order to have more flexibility, at the beginning of the script is possible to indicate different configuration files. In the main section, the inputs of the user are handled, and by means of a switch-case structure, the proper `.conf` file is selected in accordance.

An example of use is the following:
```bash
./ap.sh -d -w wlan0 -e eth0 wpa3-pk
```
