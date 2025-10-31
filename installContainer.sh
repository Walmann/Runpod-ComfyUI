#!/usr/bin/env bash

download_model_and_node_list(){
    git clone "https://github.com/Walmann/Runpod-ComfyUI"
    mv -f Runpod-ComfyUI/* /
    rm -rf Runpod-ComfyUI
    # # Nodes:
    # border "Downloading Models and Node installer wizard"
    # curl -L --progress-bar "https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/installNodes.sh" -o "/installNodes.sh" 
    # # Models: 
    # curl -L --progress-bar "https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/installModels.sh" -o "/installModels.sh" 
    # # CloseUpShop Backup: 
    # curl -L --progress-bar "https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/closeUpShop.sh" -o "/closeUpShop.sh" 

}

if [ "$1" == "downloadOnly" ]; then
    download_model_and_node_list
    exit 1
fi


apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  # Python:
  python3-dev \
  python3-pip \
  # python3.12-venv \
  python3.10-venv \
  # For running multiple services:
  supervisor \
  # Other
  nano \
  curl \
  wget \
  ffmpeg\
  pkg-config \
  tmux \
  git
#   git && \
#   apt-get autoremove -y && \
#   rm -rf /var/lib/apt/lists/* && \
#   apt-get clean -y


# Download Repository, but we only need files from a single folder...
download_model_and_node_list


# Start processes.
supervisord -c ./service_script.conf