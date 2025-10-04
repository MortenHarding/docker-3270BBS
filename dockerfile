# Using Alpine as a base
FROM alpine:latest AS build
RUN apk --update add gcc make g++ zlib-dev python3 ncurses-dev git 

WORKDIR /home
RUN wget https://x3270.bgp.nu/download/04.04/suite3270-4.4ga6-src.tgz \
&& gunzip suite3270-4.4ga6-src.tgz \
&& tar -xvf suite3270-4.4ga6-src.tar

WORKDIR /home/suite3270-4.4
RUN ./configure --enable-c3270 \
&& make install

FROM alpine:latest AS base
RUN apk add ncurses-dev sqlite git tzdata py3-tornado py3-terminado openssl wget curl jq sudo
COPY --from=build /usr/local/bin/c3270 /usr/local/bin
ENV OSTYPE=linux

#Clone the 3270BBS repo
RUN git clone --depth=1 https://github.com/moshix/3270BBS.git /opt/3270bbs \
&& sed -i 's/bash/sh/' /opt/3270bbs/start_bbs.bash \
&& sed -i 's/bash/sh/' /opt/3270bbs/create_tsudb.bash \
&& mkdir -p /opt/3270bbs/data \
&& mkdir -p /opt/3270bbs/cert

#Install web3270
RUN git clone --depth=1 https://github.com/MVS-sysgen/web3270.git /opt/web3270 \
&& rm /opt/web3270/web3270.ini \
&& openssl req -x509 -nodes -days 365 \
    -subj  "/C=CA/ST=QC/O=web3270 Inc/CN=3270.web" \
    -newkey rsa:2048 -keyout /opt/3270bbs/cert/ca.key \
    -out /opt/3270bbs/cert/ca.csr

COPY web3270.config run.sh /opt/web3270/

WORKDIR /opt/3270bbs
COPY tsu.config startup.sh getTSU.sh ./
RUN chmod +x startup.sh \
&& chmod +x getTSU.sh \
&& chmod +x /opt/web3270/run.sh

ENTRYPOINT ["./startup.sh"]