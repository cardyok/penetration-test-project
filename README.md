# cs460-final-project
Gaining access to WPA/WPA2 with short/easy password and inject mining script

Part 1. Gaining access to WIFI:
      What I did:
Install kali
Buy and hook a NIC (alfa awus036neh) that can use monitor mode to VM
	ifconfig wlan0 down && iwconfig wlan0 mode monitor && ifconfig wlan0 up
	OR
	airmon-ng start wlan0
Sniff the environment for victim WIFI and capture bssid
Sniff the MAC address of clients connected to it
Get the handshake traffic. WPA/WPA2 is more secure than WEP so I need to capture WPA/WPA2 handshake traffic since it contains Message Integrity Code (MIC) sent from client.  To get the handshake traffic, I will use deauthentication attack to kick a current client offline and capture it’s traffic when it reconnects. The deauthentication attack is done with aireplay-ng --deauth
      6.   Crack the password. 
6a. Get a wordlist. I did two approaches for this part. 
   a. I just downloaded wordlists from https://github.com/berzerk0/Probable-Wordlists/tree/master/Real-Passwords/WPA-Length 
   b. I generated my custom wordlist. Since when I am attacking my own wifi, I have some information about the password pattern and it makes the process easier. In real word I am assuming this process is done by social engineering. 

6b. Then compare it with locally generated MIC from password from wordlist to find the correct password. This process is done with aircrack-ng. 

Part 2. Injecting malicious script to victim machine.

