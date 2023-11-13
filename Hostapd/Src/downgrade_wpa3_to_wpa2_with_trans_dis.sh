#!/bin/bash

# 1. Turn on AP with WPA2
./ap.sh rogue-wpa3-with-wpa2

sleep 3

# 2. Turn on real AP with WPA3
./ap.sh wpa2-wpa3

sleep 3

# 3. Turn on rogue AP with SAE (no SAE-PK)
./ap.sh rogue-wpa3-with-wpa2
