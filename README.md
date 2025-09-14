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
- [Build the container](#build-the-container-using-the-dockerfile-in-this-repo)

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

* hostname.domain.net to the hostname you want the 3270 BBS to run as
* TZ=Europe/Copenhagen to your timezone
* -p to match the ports you require

```sh
docker run -dit --rm --name 3270BBS -h hostname.domain.net -e TZ=Europe/Copenhagen -v ./data:/opt/3270bbs/data -v ./log:/var/log -p 2022:2022 -p 9000:9000 -p 3270:3270 -p 3271:3271 mhardingdk/3270bbs:latest
```

Note: The files tsu.db, tsu.greet and the tsu.cnf file, will be created in a subfolder ./data, 3270bbs.log in a subfolder ./log, and will not be deleted if you stop and delete the container. 
This will ensure that any changes made to the tsu.cnf, tsu.greet or the tsu.db, will be used at next startup.

## Connect to 3270 BBS

Connect to the 3270 BBS using your prefered 3270 terminal emulator, or use the c3270 emulator in the container.

```sh
docker exec -it 3270BBS c3270 localhost:3270
```

# SQLite tips for the container

## Connect to tsu.db in the running container

```sh
docker exec -it 3270BBS sqlite3 tsu.db
```

## Backup the sqlite tsu.db

This will output the sql statements to a file to save it as a backup.

Full backup:
```sh
docker exec -it 3270BBS sqlite3 ./data/tsu.db '.backup ./data/full-backup.dmp'

```

## Restore the sqlite tsu.db

This will output the sql statements to a file to save it as a backup.

Full restore:
```sh
rm ./data/tsu.db* 
cp data/full-backup.dmp data/tsu.db
```

# Build the container using the dockerfile in this repo

```sh
docker build -t My-3270bbs .
```




