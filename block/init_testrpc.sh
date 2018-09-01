#!/bin/sh
# this script initializes a ganache-cli database with the sonar contract and a bunch of addresses
# requires a node runtime
set -e

RPC_FOLDER="data/ganache-clli_persist"

# make sure ganache-cli starts with an empty data directory
rm -rf ${RPC_FOLDER} && mkdir -p ${RPC_FOLDER}

# install ganache-cli 
echo "Installing node dependencies.."
#npm cache verify > /dev/null
#npm i > /dev/null

# start ganache-cli
echo "Starting ganache-cli.."
node_modules/.bin/ganache-cli --db ${RPC_FOLDER} --accounts 42 --seed 20170812 > /dev/null &
sleep 3 # wait for ganache-cli to fully start

echo "Compile and deploy Sonar contract.."
npm run postinstall
# TODO: Figure out how to grep/awk the modelrepository from here..


echo "Done!"
