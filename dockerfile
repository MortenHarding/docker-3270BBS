# Using Alpine as a base
FROM alpine:latest AS base
RUN apk add ncurses-dev sqlite git tzdata openssl wget curl jq sudo
ENV OSTYPE=linux

#Clone the 3270BBS repo
RUN git clone --depth=1 https://github.com/moshix/3270BBS.git /opt/3270bbs \
&& sed -i 's/bash/sh/' /opt/3270bbs/start_bbs.bash \
&& mkdir -p /opt/3270bbs/data \
&& mkdir -p /opt/3270bbs/cert

WORKDIR /opt/3270bbs
COPY tsu.db.bak tsu.config tsu.logon.message startup.sh getTSU.sh ./
RUN chmod +x startup.sh \
&& chmod +x getTSU.sh

ENTRYPOINT ["./startup.sh"]