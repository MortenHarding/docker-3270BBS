# Using Alpine as a base
FROM alpine:latest AS build
RUN apk --update add wget curl jq gcc make g++ zlib-dev python3 ncurses-dev sqlite git sudo tzdata

WORKDIR /home
COPY getTSU.sh /home/
RUN wget https://x3270.bgp.nu/download/04.04/suite3270-4.4ga6-src.tgz \
&& gunzip suite3270-4.4ga6-src.tgz \
&& tar -xvf suite3270-4.4ga6-src.tar

#Download latest version of 3270BBS from github
ARG PLATFORM="amd64"
RUN chmod +x /home/getTSU.sh \
&& /home/getTSU.sh ${PLATFORM}

WORKDIR /home/suite3270-4.4
RUN ./configure --enable-c3270 \
&& make install

FROM alpine:latest AS base
RUN apk add ncurses-dev sqlite git sudo tzdata py3-tornado py3-terminado openssl

COPY --from=build /usr/local/bin/c3270 /usr/local/bin
ENV OSTYPE=linux

#Install web3270
RUN git clone --depth=1 https://github.com/MVS-sysgen/web3270.git /opt/web3270 \
&& rm /opt/web3270/web3270.ini \
&& openssl req -x509 -nodes -days 365 \
    -subj  "/C=CA/ST=QC/O=web3270 Inc/CN=3270.web" \
    -newkey rsa:2048 -keyout /opt/web3270/ca.key \
    -out /opt/web3270/ca.csr

COPY web3270.config run.sh /opt/web3270/

#Install 3270 BBS
RUN git clone --depth=1 https://github.com/moshix/3270BBS.git /opt/3270bbs
COPY --from=build /home/tsu /opt/3270bbs

RUN chmod +x /opt/3270bbs/tsu \
&& ln -s /opt/3270bbs/tsu /opt/3270bbs/3270BBS \
&& sed -i 's/bash/sh/' /opt/3270bbs/start_bbs.bash \
&& sed -i 's/bash/sh/' /opt/3270bbs/create_tsudb.bash \
&& mkdir -p /opt/3270bbs/data

WORKDIR /opt/3270bbs
COPY tsu.config startup.sh ./
RUN chmod +x startup.sh \
&& chmod +x /opt/web3270/run.sh

ENTRYPOINT ["./startup.sh"]