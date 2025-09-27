#!/usr/bin/env bash

# Set variables
export DOCKER_REPO="mhardingdk/3270bbs"
export DOCKER_CONTAINERNAME="macbbs"
export DOCKER_DOMAINNAME="harding.dk"
export DOCKER_HOSTNAME="$DOCKER_CONTAINERNAME.$DOCKER_DOMAINNAME"
export DOCKER_IMAGE_TAG="latest"
export DOCKER_DATA_VOL="./data:/opt/3270bbs/data"
export DOCKER_LOG_VOL="./log:/var/log"
export DOCKER_PORT="3270:3270"

# Remove all existing docker images and build cache
# Please make sure you understand what this does before running this line.
read -p "Run docker system prune -af (y/n)?" choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    docker system prune -af
fi

# Build new image
PLATFORM=$(uname -m)
if [[ "$PLATFORM" == "s390x" ]]; then
    export DOCKER_IMAGE_TAG="$PLATFORM"
    echo "docker build --build-arg PLATFORM=$PLATFORM -t $DOCKER_REPO:$DOCKER_IMAGE_TAG ."
    docker build --build-arg PLATFORM="$PLATFORM" -t "$DOCKER_REPO":"$DOCKER_IMAGE_TAG" .
else
    echo "docker build -t $DOCKER_REPO:$DOCKER_IMAGE_TAG ."
    docker build -t "$DOCKER_REPO":"$DOCKER_IMAGE_TAG" .
fi

# Start a container on the new image to verify it's working
echo "docker run -it --rm --name $DOCKER_CONTAINERNAME -h $DOCKER_HOSTNAME -v $DOCKER_DATA_VOL -v $DOCKER_LOG_VOL -p $DOCKER_PORT $DOCKER_REPO:$DOCKER_IMAGE_TAG"
docker run -it --rm --name "$DOCKER_CONTAINERNAME" -h "$DOCKER_HOSTNAME" -v "$DOCKER_DATA_VOL" -v "$DOCKER_LOG_VOL"  -p "$DOCKER_PORT" "$DOCKER_REPO":"$DOCKER_IMAGE_TAG"
echo

# Push new docker image to hub.docker.com. Change to your own repo in Docker hub, before running this line.
read -p "Run docker push $DOCKER_REPO:$DOCKER_IMAGE_TAG (y/n)?" choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    docker push "$DOCKER_REPO":"$DOCKER_IMAGE_TAG"
fi

# Remove all existing docker images and build cache
# Please make sure you understand what this does before running this line.
read -p "Run docker system prune -af (y/n)?" choice
if [[ "$choice" =~ ^[Yy]$ ]]; then
    docker system prune -af
fi

# Test that the new image can be loaded from hup.docker.com. Only needed when refreshing the container image in mhardingdk/3270bbs:latest
echo "docker run -it --rm --name $DOCKER_CONTAINERNAME -h $DOCKER_HOSTNAME -v $DOCKER_DATA_VOL -v $DOCKER_LOG_VOL -p $DOCKER_PORT $DOCKER_REPO:$DOCKER_IMAGE_TAG"
docker run -it --rm --name "$DOCKER_CONTAINERNAME" -h "$DOCKER_HOSTNAME" -v "$DOCKER_DATA_VOL" -v "$DOCKER_LOG_VOL"  -p "$DOCKER_PORT" "$DOCKER_REPO":"$DOCKER_IMAGE_TAG"
