#!/bin/bash -e

wget -qO- https://get.docker.com/ | sh
cd
mkdir -p data/cache data/restore data/www
chmod -R 777 data
