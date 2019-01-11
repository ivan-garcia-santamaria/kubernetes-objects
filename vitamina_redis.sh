#!/bin/bash

apt -y update && apt -y upgrade

apt -y install wget && apt-get -y install build-essential
wget http://download.redis.io/releases/redis-5.0.3.tar.gz
tar xvfz redis-5.0.3.tar.gz
cd redis-5.0.3
make
src/redis-cli -h 10.0.0.3 --scan