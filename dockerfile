# Using Alpine as a base
FROM alpine:latest AS build
RUN apk --update add gcc make g++ zlib-dev python3 ncurses-dev sqlite git sudo tzdata

WORKDIR /home
RUN wget https://x3270.bgp.nu/download/04.04/suite3270-4.4ga6-src.tgz \
&& gunzip suite3270-4.4ga6-src.tgz \
&& tar -xvf suite3270-4.4ga6-src.tar

WORKDIR /home/suite3270-4.4
RUN ./configure --enable-c3270 \
&& make install

FROM alpine:latest AS base
RUN apk add ncurses-dev sqlite git sudo tzdata

COPY --from=build /usr/local/bin/c3270 /usr/local/bin

ENV OSTYPE=linux

RUN git clone https://github.com/moshix/3270BBS.git /opt/3270bbs \
&& wget  -O /opt/3270bbs/tsu https://github.com/moshix/3270BBS/releases/download/28.1/3270BBS-linux-amd64 \
&& chmod +x /opt/3270bbs/tsu \
&& ln -s /opt/3270bbs/tsu /opt/3270bbs/3270BBS \
&& sed -i 's/bash/sh/' /opt/3270bbs/start_bbs.bash \
&& sed -i 's/bash/sh/' /opt/3270bbs/create_tsudb.bash \
&& mkdir -p /opt/3270bbs/data

WORKDIR /opt/3270bbs
COPY tsu.config startup.sh ./
RUN chmod +x startup.sh

ENTRYPOINT ["./startup.sh"]