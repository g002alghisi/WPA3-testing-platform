# Source code for the ESP32 board
This folder stores all the code used to test the ESP32 dev board.

As explained in the [README](../README.md) from the `ESP32/` folder, there are 2 possible ways to program the ESP32 microcontroller:
- making use of the Arduino Core;
- by means of ESP32-IDF.

In general, working with the Arduino Core is quite straightforward; however, this approach is not so granular. For example, it is not possible to work with SAE-PK.
On the other hand, leveraging the ESP32-IDF is not so easy, but allows to fully control the microcontroller. 

## Arduino Core code
Programs of this kind are programmed with the arduino IDE, where a lot of examples are available. Two of these have been slightly modified to make the first tests with the board:
- `wifi_scan`, to scan all the available WiFi networks;
- `join network`, to connect to an AP and test the Internet connection.

All these examples are also available on [GitHub](https://github.com/espressif/arduino-esp32/tree/master/libraries).

## ESP32-IDF
Also in this case, a lot of use examples for each library come with the ESP32-IDF module when installed.
In prticular, two programs have been harnessed:
- `station`, which enables the ESP32 to join a desired network protected with WPA-Personal.
- `wifi_enterprise`, that carries out a similar function of `station`, but this time with focus on WPA-Enterprise.

All these examples are also available on [GitHub](https://github.com/espressif/esp-idf/tree/master/examples).

### `station`
The code is not as simple to understand as the `join_network` Arduino counterpart, but in this case it is possible to easily select the security protocol, set the ssid and password, and enable SAE-PK by means of the project menuconfig.
However, if SAE-PK is used with the original code, it is enabled in automatic mode.
The ESP32 is thus able to use SAE-PK, but if such a network is not available, it joins networks with bare SAE. This exposes the board to evil-twin attacks.

To avoid this problem, the `station` source code has been slightly modified with respect the original one provided by Espressif:
- Now it is possible to select the SAE-PK mode between `Automatic`, `Disabled` and `Only` (default) directly from the project menuconfig. 
- A new checkbox is available to activate or deactivate the Transition Disable mechanism (that seems to be deactivate by default).
	This should prevent (after the first connection to the real AP, thus based on a Trust On First Use policy) downgrades attacks.
	However, a better analysis of this feature implementation in the ESP32-IDF firmware will be provided in [ESP32-IDF Transition Disable mechanism](#ESP32-IDF Transition Disable mechanism) section.

### `wifi_enterprise`
This time the program is quite complete out-of-the-box: further changes neither to the main code nor to the project menuconfig are required. The program carefully distinct WPA2 and WPA3 enterprise settings, preventing the user to select "no certificate is required for this network" box.

To use it, the following certificates are required inside the main folder:
- `ca.pem`, that is the root certificate used by the server to sign its certificate sent at the beginning of the TLS session;
- `client.pem`, that is the client certificate sent to the server when performing EAP-TLS or when required by the server itself;
- `client.crt`, same as above, but a different format;
- `client.key`, which contains the private key of the client associated to `client.pem`.

### ESP32-IDF Transition Disable mechanism
The behaviour of the ESP32-IDF firmware regarding the Transition Disable feature has been inspected.
At first, the attention was on WPA2/WPA3 transition mode. In this case, the board acts correctly, and once got the Transition Disable indication from the AP, it refuses to join rogue WPA2 networks.

Subsequently, SAE/SAE-PK transition mode analysis has been carried out. Sadly, it was noted that the board gets the Transition disable indication and, if in debug mode, presents to the user the information. However, it does not care too much, and if it has possibility, it tries to join a rogue WPA3 network without SAE-PK (just SAE).<br>
For this reason, the source code has been quickly analized.

In this case, `grep` comes in hand, and by trying the following commands
```bash
cd ~/.Espressif/esp-idf/    # Where I saved my installation files
grep -r "transition disable"
# Inspect the code
grep -r "transition_disable"
# Inspect the code
grep -r "TRANSITION_DISABLE_WPA3_PERSONAL"
```
the problem has been narrowed down to `esp_wpas_glue.c`.

To be honest, how the code is organized is still hazy... However, the same inspection has been done in the source folder of `wpa_supplicant`, the one available from the Ubuntu repository. There the "original" counterpart `wpas_glue.c` has been found, thus compared to the Espressif version.

It is interesting to note that the string `"TRANSITION_DISABLE_WPA3_PERSONAL"` brings to the function:
```c
// ESP32-IDF version
void wpa_supplicant_transition_disable(void *sm, u8 bitmap)
{
    wpa_printf(MSG_DEBUG, "TRANSITION_DISABLE %02x", bitmap);

    if (bitmap & TRANSITION_DISABLE_WPA3_PERSONAL) {
        esp_wifi_sta_disable_wpa2_authmode_internal();
    }   
}

// Original version
static void wpa_supplicant_transition_disable(void *_wpa_s, u8 bitmap)
{
	struct wpa_supplicant *wpa_s = _wpa_s;
	struct wpa_ssid *ssid;
	int changed = 0;

	wpa_msg(wpa_s, MSG_INFO, TRANSITION_DISABLE "%02x", bitmap);

	ssid = wpa_s->current_ssid;
	if (!ssid)
		return;

#ifdef CONFIG_SAE
	if ((bitmap & TRANSITION_DISABLE_WPA3_PERSONAL) &&
	    wpa_key_mgmt_sae(wpa_s->key_mgmt) &&
	    (ssid->key_mgmt & (WPA_KEY_MGMT_SAE | WPA_KEY_MGMT_FT_SAE)) &&
	    (ssid->ieee80211w != MGMT_FRAME_PROTECTION_REQUIRED ||
	     (ssid->group_cipher & WPA_CIPHER_TKIP))) {
		wpa_printf(MSG_DEBUG,
			   "WPA3-Personal transition mode disabled based on AP notification");
		disable_wpa_wpa2(ssid);
		changed = 1;
	}

	if ((bitmap & TRANSITION_DISABLE_SAE_PK) &&
	    wpa_key_mgmt_sae(wpa_s->key_mgmt) &&
#ifdef CONFIG_SME
	    wpa_s->sme.sae.state == SAE_ACCEPTED &&
	    wpa_s->sme.sae.pk &&
#endif /* CONFIG_SME */
	    (ssid->key_mgmt & (WPA_KEY_MGMT_SAE | WPA_KEY_MGMT_FT_SAE)) &&
	    (ssid->sae_pk != SAE_PK_MODE_ONLY ||
	     ssid->ieee80211w != MGMT_FRAME_PROTECTION_REQUIRED ||
	     (ssid->group_cipher & WPA_CIPHER_TKIP))) {
		wpa_printf(MSG_DEBUG,
			   "SAE-PK: SAE authentication without PK disabled based on AP notification");
		disable_wpa_wpa2(ssid);
		ssid->sae_pk = SAE_PK_MODE_ONLY;
		changed = 1;
	}
#endif /* CONFIG_SAE */

	if ((bitmap & TRANSITION_DISABLE_WPA3_ENTERPRISE) &&
	    wpa_key_mgmt_wpa_ieee8021x(wpa_s->key_mgmt) &&
	    (ssid->key_mgmt & (WPA_KEY_MGMT_IEEE8021X |
			       WPA_KEY_MGMT_FT_IEEE8021X |
			       WPA_KEY_MGMT_IEEE8021X_SHA256)) &&
	    (ssid->ieee80211w != MGMT_FRAME_PROTECTION_REQUIRED ||
	     (ssid->group_cipher & WPA_CIPHER_TKIP))) {
		disable_wpa_wpa2(ssid);
		changed = 1;
	}

	if ((bitmap & TRANSITION_DISABLE_ENHANCED_OPEN) &&
	    wpa_s->key_mgmt == WPA_KEY_MGMT_OWE &&
	    (ssid->key_mgmt & WPA_KEY_MGMT_OWE) &&
	    !ssid->owe_only) {
		ssid->owe_only = 1;
		changed = 1;
	}

	if (!changed)
		return;

#ifndef CONFIG_NO_CONFIG_WRITE
	if (wpa_s->conf->update_config &&
	    wpa_config_write(wpa_s->confname, wpa_s->conf))
		wpa_printf(MSG_DEBUG, "Failed to update configuration");
#endif /* CONFIG_NO_CONFIG_WRITE */
}
```
The difference is quite suspicious... It seems like the EPS32 version does not implement anything more thant the WPA2/WPA3 Transition Disable feature, but not all the others related to SAE/SAE-PK, WPA3-Enterprise and OWE.

#### Waiting for updates from Espressif...
All the files related to this claim are stored in [`Other/`](../Other/).