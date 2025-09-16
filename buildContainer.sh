#!/usr/bin/env bash

# Remove all existing docker images and build cache
# Please make sure you understand what this does before running this line.
#docker system prune -af

# Build new image 
docker build -t mhardingdk/3270bbs:latest .

# Start a container on the new image to verify it's working
docker run -it --rm --name 3270BBS -h hostname.domain.net -e TZ=Europe/Copenhagen -v ./data:/opt/3270bbs/data -v ./log:/var/log -p 2022:2022 -p 9000:9000 -p 3270:3270 -p 3271:3271 -p 4443:443 mhardingdk/3270bbs:latest

# Push new docker image to hub.docker.com. Change to your own repo in Docker hub, before running this line.
#docker push mhardingdk/3270bbs:latest

# Remove all existing docker images and build cache
# Please make sure you understand what this does before running this line.
#docker system prune -af

# Test that the new image can be loaded from hup.docker.com. Only needed when refreshing the container image in mhardingdk/3270bbs:latest
#docker run -it --rm --name 3270BBS -h hostname.domain.net -e TZ=Europe/Copenhagen -v ./data:/opt/3270bbs/data -v ./log:/var/log -p 2022:2022 -p 9000:9000 -p 3270:3270 -p 3271:3271 -p 4443:443 mhardingdk/3270bbs:latest
