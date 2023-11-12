#!/bin/bash

# 1. Set up an AP with SAE-PK.
# 2. Connect to it.
# 3. Turn AP off.
# 4. Set up an evil-twin.
# 5. Connect to it.

./ap.sh wpa3-pk

sleep 3

./ap.sh rogue-wpa3-pk-without-pk

sleep 3

./ap.sh rogue-wpa3-pk-wrong-priv-key
