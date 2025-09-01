#!/usr/bin/env sh

#Create tsu.db if it doesn't exist in ./data
if [ ! -f "./data/tsu.db" ]; then
    echo "*** tsu.db does not exist ***"
    ./create_tsudb.bash tsu.db
    mv tsu.db* ./data
fi

#Create links if they do not exist
if [ ! -f "tsu.db" ]; then
    echo "*** tsu.db link does not exist ***"
    ln -s ./data/tsu.db tsu.db
    ln -s ./data/tsu.db-shm tsu.db-shm
    ln -s ./data/tsu.db-wal tsu.db-wal
fi

#Create tsu.cnf if it doesn't exist
if [ ! -f "./data/tsu.cnf" ]; then
    echo "*** tsu.cnf does not exist ***"
    cp tsu.config ./data/tsu.cnf
    ln -s ./data/tsu.cnf tsu.cnf
fi

#Move tsu.greet to ./data
if [ ! -f "./data/tsu.greet" ]; then
    echo "*** ./data/tsu.greet does not exist ***"
    mv tsu.greet ./data
    ln -s ./data/tsu.greet tsu.greet
fi
./start_bbs.bash