#!/usr/bin/env bash

apt-get install -y \
    ffmpeg \
    Pillow

cd workspace
wget https://github.com/9001/copyparty/releases/latest/download/copyparty-sfx.py


python3 ./copyparty-sfx.py -ups-who: 2