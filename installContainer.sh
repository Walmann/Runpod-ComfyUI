#!/usr/bin/env bash

border()
{
    # Creates a border around text
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    echo "$edge"
    echo "$title"
    echo "$edge"
}


download_model_and_node_list(){
    git clone "https://github.com/Walmann/Runpod-ComfyUI"
    echo "Content of Runpod-ComfyUI/scripts:"
    ls Runpod-ComfyUI/scripts
    mv -f Runpod-ComfyUI/scripts/* /

    echo "Content of Runpod-ComfyUI/configs:"
    ls Runpod-ComfyUI/configs
    mkdir /workspace/configs/
    mv -f Runpod-ComfyUI/configs/* /workspace/configs/
    rm -rf Runpod-ComfyUI

    echo "Moving to root folder"

    echo "Setting executables"
    chmod +x /installComfyUI.sh
    
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

border "Updating system"

apt-get -qq update && \
  apt-get -qq  upgrade -y && \
  apt-get -qq  install -y python3-dev python3-pip python3.10-venv supervisor nano curl wget ffmpeg pkg-config tmux git

echo "Finnished updating system"

# Download Repository, but we only need files from a single folder...
border "Downloading scripts"
download_model_and_node_list

border "Starting supervisor, to run multiple processes"
# Start processes.
supervisord -c ./service_script.conf