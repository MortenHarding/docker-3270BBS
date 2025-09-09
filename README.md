# 3270bbs Docker container

The Docker Container in this repo contain the [3270 BBS](https://github.com/moshix/3270BBS), which is created and built by [moshix](https://github.com/moshix), a briliant gentleman in the mainframe community. 
All credit for the [3270 BBS](https://github.com/moshix/3270BBS) goes to [moshix](https://github.com/moshix).

You can easily install 3270 BBS without this docker container, by following the instructions on [3270 BBS](https://github.com/moshix/3270BBS).

So why this docker container ?
The benefits is what you get with any app that is containerized, such as easy deployment.

# Start the 3270BBS docker container

Note that the database file tsu.db, tsu.greet and the tsu.cnf file, will be created in a subfolder ./data and will not be deleted if you stop and delete the container. 
This will ensure that any changes made to the tsu.cnf file or the tsu.db, will be used at next startup.

```sh
docker run -dit --rm --name 3270BBS -h hostname.domain.net -e TZ=Europe/Copenhagen -v ./data:/opt/3270bbs/data -v ./log:/var/log -p 2022:2022 -p 9000:9000 -p 3270:3270 -p 3271:3271 mhardingdk/3270bbs:latest
```

# Connect to 3270 BBS using the included c3270 emulator

```sh
docker exec -it 3270BBS c3270 localhost:3270
```

# Build the container using the dockerfile in this repo

```sh
docker build -t docker-3270bbs .
```

# Connect to the shell in the running container

```sh
docker exec -it 3270BBS /bin/sh
```

# Connect to tsu.db in the running container

```sh
docker exec -it 3270BBS sqlite3 tsu.db
```

# Backup the sqlite tsu.db

This will output the sql statements to a file to save it as a backup.

Full backup:
```sh
docker exec -it 3270BBS sqlite3 ./data/tsu.db '.backup ./data/full-backup.dmp'

```

# Restore the sqlite tsu.db

This will output the sql statements to a file to save it as a backup.

Full restore:
```sh
rm ./data/tsu.db* 
cp data/full-backup.dmp data/tsu.db
```

