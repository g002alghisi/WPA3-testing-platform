# Build folder
This folder contains built code. In particular:
`wpa_supplicant` comes from the build process of the code from the official Ubuntu repository.
The following process has been used:
1. Download the code from the Ubuntu repository by doing
    ```bash
    apt source wpasupplicant
    ```
2. Go to the `wpa_supplicant/` folder.
3. Create the `.config` file by means of the command
    ```bash
    cp defconf .config
    ```
4. Check if the `.config` file contains the two following strings (and are uncommented):
    ```bash
    CONFIG_SAE=y
    CONFIG_SAE_PK=y
    ```
5. Finally, execute
    ```bash
    make
    ```

> If the `wpa_supplicant` version is equal or greater than the 2.11,
> then the `.config` file should already contains the two strings to allow the use of SAEand SAE_PK
> (this is valid for the code that can be found at [http://w1.fi/hostap.git](http://w1.fi/hostap.git)
> and [https://github.com/vanhoefm/hostap-wpa3.git](https://github.com/vanhoefm/hostap-wpa3.git))

It is important to highlight that in the `.config` build file there are a lot of other features that are not enabled by default (like OCV). If a new Station configuration doesn't work properly, please checkout if all the required `CONFIG` strings are enabled at build time.
