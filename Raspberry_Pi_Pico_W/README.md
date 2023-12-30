# Raspberry Pi Pico W

- [Documentation page](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html)
- [Getting started guide](https://datasheets.raspberrypi.com/picow/connecting-to-the-internet-with-pico-w.pdf?_gl=1*de08zf*_ga*MTc0MjU3MzI1Ni4xNjk3NDY1MTI1*_ga_22FD70LWDS*MTcwMjA1NDcxMS4xMS4xLjE3MDIwNTUxMTAuMC4wLjA.)
- [Pico SDK documentation page](https://www.raspberrypi.com/documentation/pico-sdk/)
- [Another getting started guide](https://projects.raspberrypi.org/en/projects/get-started-pico-w/1)

## WPA3 or not?

- [This forum query](https://forums.raspberrypi.com/viewtopic.php?t=361300) highlight the problem:[the official documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html) of the Pico W states that WPA3 is supported, but both [the Raspberry Pi Pico C/C++ SDK documentation](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-c-sdk.pdf?_gl=1*1inacpx*_ga*MTc0MjU3MzI1Ni4xNjk3NDY1MTI1*_ga_22FD70LWDS*MTcwMzkyOTQ2Mi4xNi4wLjE3MDM5Mjk0NjIuMC4wLjA.) and [the Raspberry Pi Pico Python SDK documentation](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-python-sdk.pdf?_gl=1*mu296v*_ga*MTc0MjU3MzI1Ni4xNjk3NDY1MTI1*_ga_22FD70LWDS*MTcwMzkyOTQ2Mi4xNi4xLjE3MDM5Mjk5NTAuMC4wLjA.) do not show support for WPA3.

### MicroPython

1. By inspecting the firmware source code that can be get by doing

    ```
    git clone https://github.com/micropython/micropython.git --branch master
    ```

    After that, the brute force approach has been adopted:

    ```
    cd mycropython

    grep -ri "wpa3"
    # Micropython has references to WPA3

    grep -ri "CYW43_AUTH_" *
    # No WPA3 support found.
    # Better to check the documentation
    ```

2. Then, a look at the Micropython Networking documentation was given. [This page](https://docs.micropython.org/en/latest/library/network.WLAN.html) shows that WPA3 is not available in Micropython.
    Other users complains this lack, such as with [this post](https://github.com/micropython/micropython/issues/8103)
    However, it is not clear where the cyw43 driver is located (the lib/cyw43-driver/ folder is empty). Probably the driver is the same installed with the Pico-SDK.

    The `ports/rp2/CMakeLists.txt` file has the following instruction:

    ```
    # Use the local cyw43_driver instead of the one in pico-sdk
    if (MICROPY_PY_NETWORK_CYW43)
        set(PICO_CYW43_DRIVER_PATH ${MICROPY_DIR}/lib/cyw43-driver)
    endif()
    ```

    But the `drivers/cyw43/README.md` file states:

    ```
    CYW43xx WiFi SoC driver
    =======================                                                                       

    This is a driver for the CYW43xx WiFi SoC.

    There are four layers to the driver:

    1. SDIO bus interface, provided by the host device/system.

    2. Low-level CYW43xx interface, managing the bus, control messages, Ethernet
    frames and asynchronous events.  Includes download of SoC firmware.  The 
    header file `cyw43_ll.h` defines the interface to this layer.

    3. Mid-level CYW43xx control, to control and set WiFi parameters and manage
    events.  See `cyw43_ctrl.c`.

    4. TCP/IP bindings to lwIP.  See `cyw43_lwip.c`.
    ```

    and this is the same structure as the one described [here](https://cec-code-lab.aps.edu/robotics/resources/pico-c-api/group__cyw43__driver.html) for the Raspberry Pi Pico W.
    The problem seems to be now related to the Pico W SDK.

3. From [the main GitHub page](https://github.com/micropython/micropython/tree/master) of the Micropython project, the [external dependencies](https://github.com/micropython/micropython/tree/master#external-dependencies) section redirect to the [several submodules](https://github.com/micropython/micropython/blob/master/lib) page.
    There, by means of [the cwy34 GitHub page link](https://github.com/georgerobotics/cyw43-driver/tree/2ab0db6e1fe9265fa9802a95f7f4d60b7f0d655a) it is possible to inspect the driver source code used with Micropython.

    From there it is possible to download the source code and inspect it (commit b7195d8).

    ```
    # 1. Clone the repo
    git clone https://github.com/georgerobotics/cyw43-driver.git

    # 2. Change directory
    cd cyw43-driver
    
    # 3. Grep "wpa"
    grep -ri "wpa2"
    # The relevant file is src/cyw43_ll.h

    # 4. Check the src/cyw43_ll.h file
    vim src/cyw43_ll.h
    ```

    From vim it is possible to find the section

    ```
    /**
    * \name Authorization types
    * \brief Used when setting up an access point, or connecting to an access point
    * \anchor CYW43_AUTH_
    */
    //!\{
    #define CYW43_AUTH_OPEN (0)                     ///< No authorisation required (open)
    #define CYW43_AUTH_WPA_TKIP_PSK   (0x00200002)  ///< WPA authorisation
    #define CYW43_AUTH_WPA2_AES_PSK   (0x00400004)  ///< WPA2 authorisation (preferred)
    #define CYW43_AUTH_WPA2_MIXED_PSK (0x00400006)  ///< WPA2/WPA mixed authorisation
    //!\}
    ```

    Thus, no support for WPA3 nor WPA-Enterprise has been found.

### C SDK

1. First of all, a look at [the Pico W documentation](https://www.raspberrypi.com/documentation/pico-sdk/networking.html) was given.
    Looking around it is possible to find [`CYW43_AUTH_` references](https://www.raspberrypi.com/documentation/pico-sdk/networking.html#CYW43_AUTH_)

    > [this document](https://datasheets.raspberrypi.com/picow/connecting-to-the-internet-with-pico-w.pdf?_gl=1*1yn25g8*_ga*MTc0MjU3MzI1Ni4xNjk3NDY1MTI1*_ga_22FD70LWDS*MTcwMzkyOTQ2Mi4xNi4xLjE3MDM5MzE1NjMuMC4wLjA.) refers just to the `libcyw43` library for both the Python and C SDK. However, by clicking on the link to the license information it is possible to get to the georgerobotics/cyw43-driver GitHub page. Thus, the same driver is used for both. But this time it is possible to inspect the official documentation.

Accordingly to [this forum query](https://forums.raspberrypi.com/viewtopic.php?t=361300) highlight the problem:[the official documentation](https://www.raspberrypi.com/documentation/microcontrollers/raspberry-pi-pico.html) of the Pico W states that WPA3 is supported, but both [the Raspberry Pi Pico C/C++ SDK documentation](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-c-sdk.pdf?_gl=1*1inacpx*_ga*MTc0MjU3MzI1Ni4xNjk3NDY1MTI1*_ga_22FD70LWDS*MTcwMzkyOTQ2Mi4xNi4wLjE3MDM5Mjk0NjIuMC4wLjA.) and [the Raspberry Pi Pico Python SDK documentation](https://datasheets.raspberrypi.com/pico/raspberry-pi-pico-python-sdk.pdf?_gl=1*mu296v*_ga*MTc0MjU3MzI1Ni4xNjk3NDY1MTI1*_ga_22FD70LWDS*MTcwMzkyOTQ2Mi4xNi4xLjE3MDM5Mjk5NTAuMC4wLjA.) do not show support for WPA3.

## WPA Enterprise

The same problem as WPA3. The Pico SDK does not support it, as explained [in the last commento of this reply](https://raspberrypi.stackexchange.com/questions/139096/how-can-i-connect-my-raspberry-pi-pico-w-to-an-eduroam-wifi-access-point-wpa-au).

The official [Pico SDK documentation](https://www.raspberrypi.com/documentation/pico-sdk/networking.html) does not include any informationrelated to Enterprise.
