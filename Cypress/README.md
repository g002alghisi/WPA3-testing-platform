# Cypress CYW954907AEVAL1F Board

1. [Introduction](#introduction)
2. [Working with the Cypress board](#working-with-the-cypress-board)
3. [Testing the board](#testing-the-board)

## Introduction

The Cypress CYW954907AEVAL1F Evaluation Kit serves as a platform for assessing and developing single-chip Wi-Fi applications using the CYW54907 device.
This kit is centered around a module that harnesses the capabilities of the CYW54907, a single-chip 802.11ac dual-band Wi-Fi System-on-Chip (SoC) supporting both 2.4 GHz and 5 GHz frequencies.
For more information, visit [Infineon's product page](https://www.infineon.com/cms/en/product/evaluation-boards/cyw954907aeval1f/).

## Working with the Cypress board

Program the board using the official SDK called WICED-Studio, available for Linux and Windows. It's highly recommended to work on a Windows PC to avoid potential issues with code building and downloading on Linux. You can also use it on a virtual machine (like VirtualBox), but consider installing an older version of Windows (e.g., 7) to avoid overloading the host system.

In addition to the SDK, a tool to read messages from the serial interface is required. Here are some recommendations:

- On Ubuntu, use `minicom`.
- On Windows, use `putty`.

A practical starting guide is available [here](https://www.infineon.com/dgdl/Infineon-CYW954907AEVAL1F_Evaluation_Kit_User_Guide-UserManual-v01_00-EN.pdf?fileId=8ac78c8c7d0d8da4017d0eff8331169e). It provides useful information, including:

- An introduction to the board and the development environment.
- Instructions on how to install the SDK and set everything up.
- A step-by-step tutorial to build, download, and run programs on the board.
- Example programs for initial testing.

In addition to the getting started guide, you can find support by searching online. However, the most accurate and comprehensive documentation is available directly inside the IDE. In the project tree, under `43xxx_Wi-Fi > doc`, several PDF files can be found, each focusing on a specific aspect of the platform. For convenience, some of them have been copied inside the [`Doc/`](Doc/) folder.

## Testing the board

The manual offers examples to start working with the board. However, the most useful and complete tool available, without delving too much into code complexity, is probably `test.console`. This program allows you to entirely control the board using a terminal-like interface.

Despite the example programs found under `43xxx_Wi-Fi > apps > snip`, the main code for `test.console` is located under `43xxx_Wi-Fi > apps > test`. Here's how to use this software:

1. Select `43xxx_Wi-Fi` in the WICED Target selector drop-down box.
2. Right-click `43xxx_Wi-Fi` in the Make Target window and click `New`.
3. Create the make target `test.console-CYW954907AEVAL1F download run`.
   - `snip` = directory inside the apps folder.
   - `scan` = sub-directory and name of the application to be built.
   - `CYW954907AEVAL1F` = board/platform name.
   - `download` = indicates download to the target.
   - `run` = resets the target and starts execution.
4. Double-click the `Clean` Make Target to remove any output from the previous build. Do this when new files are added or removed. Remember to connect the board to the PC via USB before executing the build target to avoid `download_dct` error.
5. Double-click the `test.console-CYW954907AEVAL1F download run` make target to build and download it to the CYW954907AEVAL1F board.

Once the program is loaded and running, start the terminal emulation program (such as `Putty`), select the right COM port, and set the baud rate to 115200. A black screen should appear. Press the `Reset` button on the board to run the program from the beginning, and the CLI will appear magically.

Type `help` and press enter to get a long list of interesting commands.

### Join a Wi-Fi Personal Network

The `join` command can be used to join a Wi-Fi network protected with WPA-Personal. The full syntax is:

```plain text
join <ssid> <open|wpa_aes|wpa_tkip|wpa2|wpa2_aes|wpa2_tkip|wpa2_fbt|wpa3|wpa3_wpa2> [key] [psk(for wpa3_wpa2 amode only)] [channel] [ip netmask gateway]
```

If `wpa3_wpa2` is specified, `key` and `psk` fields shall be written as the same word.

To disconnect simply use `leave`.

### Join a Wi-Fi Enterprise Network

The `join_ent` command is quite similar to the previous, but specific for WPA-Enterprise networks. The full syntax is:

```plain text
join_ent <ssid> <eap_tls|peap|eap_ttls> [username] [password] [eap] [mschapv2] [client-cert] <wpa2|wpa2_tkip|wpa|wpa_tkip|wpa2_fbt>
```

Note that `eap` and `mschapv2` can be used only if `eap_ttls` is selected.

Working with Enterprise networks is not as easy as Personal ones. Thus, the framework is explained in the document [WICED Enterprise Security User Guide](WICED-Enterprise_Security_User_Guide-Enterprise_Security_User_guide_002-22776_00_V.pdf), available under `43xxx_Wi-Fi > doc`.
Among other things, it details how to include certificates.
It is recommended to read it, but to make it short, this operation is carried out by editing the `certificate.h` file located under `43xxx_Wi-Fi > libraries > utilities > command_console > wifi`.

By inspecting the file, it is quickly noticeable how tedious can be to include the certificate inside it. To streamline the process, the `cert2cypress_cert.sh` script comes in hand.

### Getting Cypress certificates

The script `cert2cypress_cert.sh` assists users in integrating certificates into the source code of the Cypress board.
To understand the problem being addressed, consider the following example.

Suppose you have the `ca.pem` certificate related to the WPA-Enterprise framework.

```plain text
-----BEGIN CERTIFICATE-----
MIIE2zCCA8OgAwIBAgIUX1xUMI/9PqGHWrokumdrkfkNLekwDQYJKoZIhvcNAQEL
BQAwgYsxCzAJBgNVBAYTAkdMMRIwEAYDVQQIDAlOZXcgV29ybGQxDzANBgNVBAcM
BlJhZnRlbDEdMBsGA1UECgwUU3RyYXcgSGF0IE5ldHdvcmtpbmcxHjAcBgkqhkiG
9w0BCQEWD2NhQHN0cmF3aGF0LmNvbTEYMBYGA1UEAwwPY2Euc3RyYXdoYXQuY29t
MB4XDTIzMTEzMDE2MzMwNFoXDTI0MDEyOTE2MzMwNFowgYsxCzAJBgNVBAYTAkdM
MRIwEAYDVQQIDAlOZXcgV29ybGQxDzANBgNVBAcMBlJhZnRlbDEdMBsGA1UECgwU
U3RyYXcgSGF0IE5ldHdvcmtpbmcxHjAcBgkqhkiG9w0BCQEWD2NhQHN0cmF3aGF0
LmNvbTEYMBYGA1UEAwwPY2Euc3RyYXdoYXQuY29tMIIBIjANBgkqhkiG9w0BAQEF
AAOCAQ8AMIIBCgKCAQEArDyNWIrmLim11fcsu/MlLMCd0TSKeOJNyUbetsgSNhz+
zzoWwk38XHu8cA+hOe9zuOvOdC5gjHiNdpfs1MpLif/DadHCyD/au0KyGJxfdHrx
TluTOh1xKYCBrV2cEhx0O4MHwuPYIWxQKsftxU0uFGmJvyRtZYk8ixfrvNpFv4ap
cdDYRoCxYSGq6FhniaH8XGup3rf5TbNvShKpHqreb+htazGORZ1DPsEDOUfIP7D/
dC7BTnPsiCIrg54+R3qghYM1OCcRiWRo02sfpu+B34quE+Hf4pz5f+XtHdvXvJpw
j34j5R/LMcW7EODTJ4VnUHqVcss7VVGocsX2jnS+twIDAQABo4IBMzCCAS8wHQYD
VR0OBBYEFN1rHJ+ix99XYw3AYFI/GLJUNVqDMIHLBgNVHSMEgcMwgcCAFN1rHJ+i
x99XYw3AYFI/GLJUNVqDoYGRpIGOMIGLMQswCQYDVQQGEwJHTDESMBAGA1UECAwJ
TmV3IFdvcmxkMQ8wDQYDVQQHDAZSYWZ0ZWwxHTAbBgNVBAoMFFN0cmF3IEhhdCBO
ZXR3b3JraW5nMR4wHAYJKoZIhvcNAQkBFg9jYUBzdHJhd2hhdC5jb20xGDAWBgNV
BAMMD2NhLnN0cmF3aGF0LmNvbYIUX1xUMI/9PqGHWrokumdrkfkNLekwDwYDVR0T
AQH/BAUwAwEB/zAvBgNVHR8EKDAmMCSgIqAghh5odHRwOi8vd3d3LnN0cmF3aGF0
LmNvbS9jYS5jcmwwDQYJKoZIhvcNAQELBQADggEBAIoXxrIkPjPTKB2BRYz2GEdc
vb2/sVcN84uDTpChobOWp1fD8oS3IOg6P2dMjlS7/tHTtgUDfSViCdBHH+L8tpyi
+TQYEoGx1h8EtPxJXNPfL5zeEOrJK6ThRFhqO5RD9P2589o9iOccFHWD+sIlqT11
8H+kAHmhIzJERJEcU1dzHZkd3hHUcKsG1/uKvTilZQ3Ivx4IM41Ema+m5gf5zb1f
Skn6kspl8/i+vi+dIUWkZjFqTkiDH91nTx8e14PzkphHqpSgNPWFARtoTh2/Osaf
OhzkU4YMOFnTqiFeK+Fs9bCPFHOsoLLJBQ9gtkxcJ8kbEaaEjNvKMIHO/hx9pFo=
-----END CERTIFICATE-----
```

Now, let's that is required to upload this certificate to the Cypress board.
To do this, the procedure involves editing the `certificate.h` file located under `43xxx_Wi-Fi > libraries > utilities > command_console > wifi`, as follows:

```c
#define WIFI_ROOT_CERTIFICATE_STRING  \
"-----BEGIN CERTIFICATE-----\r\n"\
"MIIE2zCCA8OgAwIBAgIUX1xUMI/9PqGHWrokumdrkfkNLekwDQYJKoZIhvcNAQEL\r\n"\
"BQAwgYsxCzAJBgNVBAYTAkdMMRIwEAYDVQQIDAlOZXcgV29ybGQxDzANBgNVBAcM\r\n"\
"BlJhZnRlbDEdMBsGA1UECgwUU3RyYXcgSGF0IE5ldHdvcmtpbmcxHjAcBgkqhkiG\r\n"\
"9w0BCQEWD2NhQHN0cmF3aGF0LmNvbTEYMBYGA1UEAwwPY2Euc3RyYXdoYXQuY29t\r\n"\
"MB4XDTIzMTEzMDE2MzMwNFoXDTI0MDEyOTE2MzMwNFowgYsxCzAJBgNVBAYTAkdM\r\n"\
"MRIwEAYDVQQIDAlOZXcgV29ybGQxDzANBgNVBAcMBlJhZnRlbDEdMBsGA1UECgwU\r\n"\
"U3RyYXcgSGF0IE5ldHdvcmtpbmcxHjAcBgkqhkiG9w0BCQEWD2NhQHN0cmF3aGF0\r\n"\
"LmNvbTEYMBYGA1UEAwwPY2Euc3RyYXdoYXQuY29tMIIBIjANBgkqhkiG9w0BAQEF\r\n"\
"AAOCAQ8AMIIBCgKCAQEArDyNWIrmLim11fcsu/MlLMCd0TSKeOJNyUbetsgSNhz+\r\n"\
"zzoWwk38XHu8cA+hOe9zuOvOdC5gjHiNdpfs1MpLif/DadHCyD/au0KyGJxfdHrx\r\n"\
"TluTOh1xKYCBrV2cEhx0O4MHwuPYIWxQKsftxU0uFGmJvyRtZYk8ixfrvNpFv4ap\r\n"\
"cdDYRoCxYSGq6FhniaH8XGup3rf5TbNvShKpHqreb+htazGORZ1DPsEDOUfIP7D/\r\n"\
"dC7BTnPsiCIrg54+R3qghYM1OCcRiWRo02sfpu+B34quE+Hf4pz5f+XtHdvXvJpw\r\n"\
"j34j5R/LMcW7EODTJ4VnUHqVcss7VVGocsX2jnS+twIDAQABo4IBMzCCAS8wHQYD\r\n"\
"VR0OBBYEFN1rHJ+ix99XYw3AYFI/GLJUNVqDMIHLBgNVHSMEgcMwgcCAFN1rHJ+i\r\n"\
"x99XYw3AYFI/GLJUNVqDoYGRpIGOMIGLMQswCQYDVQQGEwJHTDESMBAGA1UECAwJ\r\n"\
"TmV3IFdvcmxkMQ8wDQYDVQQHDAZSYWZ0ZWwxHTAbBgNVBAoMFFN0cmF3IEhhdCBO\r\n"\
"ZXR3b3JraW5nMR4wHAYJKoZIhvcNAQkBFg9jYUBzdHJhd2hhdC5jb20xGDAWBgNV\r\n"\
"BAMMD2NhLnN0cmF3aGF0LmNvbYIUX1xUMI/9PqGHWrokumdrkfkNLekwDwYDVR0T\r\n"\
"AQH/BAUwAwEB/zAvBgNVHR8EKDAmMCSgIqAghh5odHRwOi8vd3d3LnN0cmF3aGF0\r\n"\
"LmNvbS9jYS5jcmwwDQYJKoZIhvcNAQELBQADggEBAIoXxrIkPjPTKB2BRYz2GEdc\r\n"\
"vb2/sVcN84uDTpChobOWp1fD8oS3IOg6P2dMjlS7/tHTtgUDfSViCdBHH+L8tpyi\r\n"\
"+TQYEoGx1h8EtPxJXNPfL5zeEOrJK6ThRFhqO5RD9P2589o9iOccFHWD+sIlqT11\r\n"\c
"8H+kAHmhIzJERJEcU1dzHZkd3hHUcKsG1/uKvTilZQ3Ivx4IM41Ema+m5gf5zb1f\r\n"\
"Skn6kspl8/i+vi+dIUWkZjFqTkiDH91nTx8e14PzkphHqpSgNPWFARtoTh2/Osaf\r\n"\
"OhzkU4YMOFnTqiFeK+Fs9bCPFHOsoLLJBQ9gtkxcJ8kbEaaEjNvKMIHO/hx9pFo=\r\n"\
"-----END CERTIFICATE-----\r\n"\
"\0"\
"\0"
```

As one can imagine, manually editing the file by adding `"` at the beginning and appending `\r\n"\` at the end of each line can be quite tedious.
Additionally, this operation may be necessary (if `eap-tls` is used) for two other files: `client.pem` and `client.key`.
But this is where `cert2cypress_cert.sh` comes into play.

The script allows for the easy selection of the FreeRADIUS configuration directory for which AS certificates are required.
The selection mechanism is the same as used by `as_ui.sh`, as well as the configuration strings.
After that, the process automatically edits the files.
The output is both displayed on the screen and stored in a directory inside `Cypress/Tmp/`.
Its name recalls of the FreeRADIUS configuration directory.
