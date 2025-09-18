# 3270 BBS Docker container

- [This Repo](#this-repo)
- [Quick start guide](#Quick-start-guide)
  - [Prerequisites](#Prerequisites) 
  - [Start the 3270 BBS docker container](#start-the-3270-bbs-docker-container)
  - [Connect to 3270 BBS in the container](#connect-to-3270-bbs)
- [SQLite tips](#sqlite-tips-for-the-container)
  - [Connect to the SQLite tsu.db](#connect-to-tsudb-in-the-running-container)
  - [Backup the SQLite tsu.db](#backup-the-sqlite-tsudb)
  - [Restore the SQLite tsu.db](#restore-the-sqlite-tsudb)
- [Build the container](#build-the-container)

# This Repo

The Docker Container in this repo contain the [3270 BBS](https://github.com/moshix/3270BBS), which is created and built by [moshix](https://github.com/moshix), a briliant gentleman in the mainframe community. 
All credit for the [3270 BBS](https://github.com/moshix/3270BBS) goes to [moshix](https://github.com/moshix).

You can easily install 3270 BBS without this docker container, by following the instructions on [3270 BBS](https://github.com/moshix/3270BBS).

So why this docker container ?
The benefits is what you get with any app that is containerized, such as easy deployment.

# Guick start guide

## Prerequisites

Install docker to use the container in this repository.

* [Docker](https://www.docker.com/get-started)

## Start the 3270 BBS docker container

Start the 3270 BBS container using the following command.

Please change:

The hostname you want the 3270 BBS to run as
* hostname.domain.net 

The timezone
* TZ=Europe/Copenhagen


```sh
docker run -dit --rm --name 3270BBS -h hostname.domain.net -e TZ=Europe/Copenhagen -v ./data:/opt/3270bbs/data -v ./log:/var/log -p 2022:2022 -p 9000:9000 -p 3270:3270 -p 3271:3271 -p 4443:443 mhardingdk/3270bbs:latest
```

Several configuration and logfiles are accessible through the volumes mounted to the docker container. The volumes are mounted as subdirectories in the folder were you execute "docker run".

The files and their location:
```sh
./data/tsu.db
./data/tsu.greet
./data/tsu.cnf
./data/tsu.logo
./data/certificate.crt
./data/private.key
./data/web3270.ini
./log/3270bbs.log
./log/web3270.log
```

This will ensure that any changes made to the tsu.cnf, tsu.greet, tsu.log, web3270.ini or the tsu.db will be used at next startup.

## Connect to 3270 BBS

Connect to the 3270 BBS using your prefered 3270 terminal emulator, or use the c3270 emulator in the container.

```sh
docker exec -it 3270BBS c3270 localhost:3270
```

The container also has web3270 setup and running on http://localhost:4443

# SQLite tips for the container

## Connect to tsu.db in the running container

```sh
docker exec -it 3270BBS sqlite3 tsu.db
```

## Backup the sqlite tsu.db

Full backup:
```sh
docker exec -it 3270BBS sqlite3 ./data/tsu.db '.backup ./data/full-backup.dmp'

```

## Restore the sqlite tsu.db

Full restore:
Stop the docker container, first and then remove the tsu.db

```sh
docker container stop 3270BBS
rm ./data/tsu.db* 
cp data/full-backup.dmp data/tsu.db
```

Start the docker container again as described in [Start the 3270 BBS docker container](#start-the-3270-bbs-docker-container)

# Build the container

Build a container, using the dockerfile from this repo, with the latest release of TSU from https://github.com/moshix/3270BBS/releases

```sh
docker build -t My-3270bbs .
```




