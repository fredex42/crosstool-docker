FROM ubuntu:latest

RUN apt-get update && apt-get -y install build-essential wget gperf bison flex texinfo help2man gawk ncurses-dev git autoconf automake unzip file libtool-bin python3 python3-dev python3-pip && rm -rf /var/cache/apt
COPY install-crosstool.sh /tmp
RUN pip3 install awscli && chmod a+x /tmp/install-crosstool.sh; /tmp/install-crosstool.sh

COPY docker-entrypoint.sh /

RUN useradd build && mkdir -p /home/build && chown build /home/build; chmod a+x /docker-entrypoint.sh

USER build
COPY glibc_version.patch /home/build

CMD /docker-entrypoint.sh
