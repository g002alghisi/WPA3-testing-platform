/*
 *  This sketch sends a message to a TCP server
 *
 */

#include <WiFi.h>

const char *wpa2_ssid = "F3-rhcn";
const char *wpa2_password = "TheCatCameBack";


void setup()
{
    Serial.begin(115200);
    delay(10);

    // We start by connecting to a WiFi network
    WiFi.begin(wpa2_ssid, wpa2_password);

    Serial.println();
    Serial.println();
    Serial.print("Waiting for WiFi... ");

    while(WiFi.status() != WL_CONNECTED) {
        Serial.print(".");
        delay(500);
    }

    Serial.println("");
    Serial.println("WiFi connected");
    Serial.print("IP address: ");
    Serial.println(WiFi.localIP());
    Serial.print("Channel: ");
    Serial.println(WiFi.channel());
    Serial.println();

    delay(500);
}


void loop()
{
    const uint16_t port = 80;
    const char *host = "httpbin.org"; // ip or dns


    Serial.print("Connecting to ");
    Serial.println(host);

    // Use WiFiClient class to create TCP connections
    WiFiClient client;

    if (!client.connect(host, port)) {
        Serial.println("Connection failed.");
        Serial.println("Waiting 5 seconds before retrying...");
        delay(5000);
        return;
    }

    // This will send a request to the server
    client.print("GET /deny HTTP/1.1\r\n");
    client.print("Host: " + String(host) + "\r\n");
    client.print("Connection: close\r\n\r\n");

    int maxloops = 0;

    //wait for the server's reply to become available
    while (!client.available() && maxloops < 1000) {
        maxloops++;
        delay(1); //delay 1 msec
    }

    while (client.available()) {
        //read back one line from the server
        String line = client.readStringUntil('\r');
        Serial.print(line);
    }

    Serial.println();
    Serial.println("Closing connection.");
    client.stop();

    Serial.println();
    Serial.println("Waiting 5 seconds before restarting...");
    Serial.println();
    delay(5000);
}