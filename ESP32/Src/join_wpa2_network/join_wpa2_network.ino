#include <WiFi.h>

const char *ssid = "Hostapd-WPA2";
const char *password = "argoargoargo";


void setup() {
    // Setup Serial communication
    Serial.begin(115200);
    while (!Serial) {
        delay(100);
    }

    // Setup the WiFi module
    WiFi.mode(WIFI_STA);
    WiFi.setMinSecurity()

}

void loop() {
  // put your main code here, to run repeatedly:

}
