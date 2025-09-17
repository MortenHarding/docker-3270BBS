#!/bin/sh
# Docker is unable to run python on its own for some reason
# This script is needed to run properly
nohup python3 -u /opt/web3270/server.py --config /opt/3270bbs/data --certs . > /var/log/web3270.log &