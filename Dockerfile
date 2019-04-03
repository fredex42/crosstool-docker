FROM ubuntu:latest

RUN apt-get update && apt-get -y install build-essential wget gperf bison flex texinfo help2man gawk ncurses-dev git autoconf automake unzip file libtool-bin python3 python3-dev && rm -rf /var/cache/apt
COPY install-crosstool.sh /tmp
RUN chmod a+x /tmp/install-crosstool.sh; /tmp/install-crosstool.sh
RUN useradd build && mkdir -p /home/build && chown build /home/build
USER build
