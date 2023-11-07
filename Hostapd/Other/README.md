# Generate a SAE-PK key for WPA3
These instructions are available at [https://github.com/vanhoefm/hostap-wpa3](https://github.com/vanhoefm/hostap-wpa3).

First generate a private key:
```
openssl ecparam -name prime256v1 -genkey -noout -out example_key.der -outform der
```
Now derive the password from it:
```
./sae_pk_gen example_key.der <3|5> <ssid_name>
```
