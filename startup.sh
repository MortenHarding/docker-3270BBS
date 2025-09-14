#!/usr/bin/env sh

#Create tsu.db if it doesn't exist in ./data
if [ ! -f "./data/tsu.db" ]; then
    echo "*** Creating ./data/tsu.db ***"
    ./create_tsudb.bash tsu.db
    mv tsu.db* ./data
fi

#Create tsu.db links if they do not exist
if [ ! -f "tsu.db" ]; then
    echo "*** Creating tsu.db link ***"
    ln -s ./data/tsu.db tsu.db
    ln -s ./data/tsu.db-shm tsu.db-shm
    ln -s ./data/tsu.db-wal tsu.db-wal
fi

#Create tsu.cnf if it doesn't exist
if [ ! -f "./data/tsu.cnf" ]; then
    echo "*** Creating ./data/tsu.cnf ***"
    cp tsu.config ./data/tsu.cnf
fi

#Create tsu.cnf link if it doesn't exist
if [ ! -f "tsu.cnf" ]; then
    echo "*** Creating tsu.cnf link ***"
    ln -s ./data/tsu.cnf tsu.cnf
fi

#Move tsu.greet to ./data and create link
if [ ! -f "./data/tsu.greet" ]; then
    echo "*** Creating ./data/tsu.greet ***"
    mv tsu.greet ./data
    echo "*** Creating tsu.greet link ***"
    ln -s ./data/tsu.greet tsu.greet
    else
    echo "*** Creating tsu.greet link ***"
    rm tsu.greet
    ln -s ./data/tsu.greet tsu.greet
fi
./start_bbs.bash