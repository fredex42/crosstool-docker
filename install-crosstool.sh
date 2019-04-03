#!/bin/bash -e

### Install crosstool-ng
mkdir -p /usr/src
cd /usr/src
#wget http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.23.0.tar.bz2
#tar xjf crosstool-ng-1.23.0.tar.bz2
git clone https://github.com/crosstool-ng/crosstool-ng

cd crosstool-ng
./bootstrap
ls -lh
./configure --prefix=/usr/local
make -j4 && make install
cd /usr/src
rm -rf crosstool-ng*
