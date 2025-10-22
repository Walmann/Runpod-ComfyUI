#!/usr/bin/env bash

apt-get install -y \
    ffmpeg \
    python3-pil

cd workspace
wget https://github.com/9001/copyparty/releases/latest/download/copyparty-sfx.py


python3 ./copyparty-sfx.py