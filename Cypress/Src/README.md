# Cypress `Src/` Folder
This directory contains the `cert2cypress_cert.sh` bash script.

The script assists users in integrating certificates into the source code of the Cypress board.
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
"+TQYEoGx1h8EtPxJXNPfL5zeEOrJK6ThRFhqO5RD9P2589o9iOccFHWD+sIlqT11\r\n"\
"8H+kAHmhIzJERJEcU1dzHZkd3hHUcKsG1/uKvTilZQ3Ivx4IM41Ema+m5gf5zb1f\r\n"\
"Skn6kspl8/i+vi+dIUWkZjFqTkiDH91nTx8e14PzkphHqpSgNPWFARtoTh2/Osaf\r\n"\
"OhzkU4YMOFnTqiFeK+Fs9bCPFHOsoLLJBQ9gtkxcJ8kbEaaEjNvKMIHO/hx9pFo=\r\n"\
"-----END CERTIFICATE-----\r\n"\
"\0"\
"\0"
```

As one can imagine, manually editing the file by adding `"` at the beginning of and appending `\r\n"\` at the end of each line can be quite tedious.
Additionally, this operation may be necessary (if `eap-tls` is used) for two other files: `client.pem` and `client.key`.
But this is where `cert2cypress_cert.sh` comes into play.

The script allows for the easy selection of the FreeRADIUS configuration directory for which AS certificates are required.
The selection mechanism is the same as used by `as_ui.sh`, as well as the configuration strings.
After that, the process automatically edits the files.
The output is both displayed on the screen and stored in a directory inside `Cypress/Tmp/`.
Its name recalls of the FreeRADIUS configuration directory.