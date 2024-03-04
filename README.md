# WPA3-testing-platform

WPA3-testing-platform is a framework that easily allows to transform a generic GNU/Linux PC equipped with a wireless network card into a full hackable AP that supports the latest WPA3 mechanisms; it particular, it facilitates the creation of both WPA3-Personal and WPA3-Enterprise Wi-Fi networks.

This platform was created to streamline the testing process of the latest WPA3 features for different devices. More details about these tests are provided in the [`Test/'](./Test) folder.

## Main components

The present testing platform revolves around three main components:
- Hostapd, the user-space Linux demon that actually allows to turn the PC into an AP.
- FreeRADIUS, that allows setting up an Authentication, Authorization and Accounting server, and that in this case acts as an Authentication Server (AS) for the WPA3-Enterprise authentication procedure.
- Wpa-supplicant, the counterpart of Hostapd, that handles Wi-Fi authentication at user-space level. In particular, this component was used to check all the network configurations before undergoing them with the with the different analyzed devices.
