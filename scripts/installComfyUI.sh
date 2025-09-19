#!/usr/bin/env bash
# set -e

rootWorkspace="/workspace"
rootComfyUI="/workspace/ComfyUI"
rootModels="/workspace/ComfyUI/models"
rootCustomNodes="/workspace/ComfyUI/custom_nodes"
cd $rootWorkspace





# printf "Starting CopyParty!"
# tmux new-session -d -s copyparty 'curl -LsSf https://astral.sh/uv/install.sh | sh && source $HOME/.local/bin/env && uv tool run copyparty -p 3923 --allow-csrf' 


printf "\nNow starting installation of ComfyUI\n"
printf "Current Dir: $PWD \n"

printf "CUDA version: \n"
nvcc --version


# Create workspace dir if it does not exists. This is just for local development
mkdir -p /workspace


# Check if a python Venv already exists
if test -d ./venv; then
    # Add check for if there actually is a venv here.
    echo "Found Venv. Using that!"
    source venv/bin/activate

else
    echo "Found no Virtual enviorment. Creating one now."
    python3 -m venv venv
    source venv/bin/activate
    printf "Created Venv. Location: "
    which python
    python3 -V

fi



printf "Installing ComfyUI\n"
printf "ComfyUI: Cloning\n"

printf "Checking if $rootComfyUI exists.\n"

if [ -d "$rootComfyUI" ]; then
    echo "Repo already exists, updating..."
    cd $rootComfyUI
    git pull
    cd $rootWorkspace
else
    cd $rootWorkspace
    echo "Repo not found"
    echo "List of files in $rootComfyUI folder: "
    ls -la $rootComfyUI
    echo "Cloning: "
    git clone https://github.com/comfyanonymous/ComfyUI ComfyUI
fi

# Install some known missing packages: 
pip install opencv-python requests runpod==1.7.7 huggingface_hub



# git clone --progress "https://github.com/comfyanonymous/ComfyUI"     
echo "ComfyUI: Entering Dir"
cd $rootComfyUI
echo "ComfyUI: Installing requirements"
pip install -r requirements.txt



git_get_nodes(){
    local folderName="$2"

    cd $rootCustomNodes
    # TODO Make it check for Custom
    if [ -d "$folderName" ]; then
        echo "Node already exists, updating..."
        cd "$folderName"
        git pull
    else
        echo "Node not found"
        # echo "List of files in $ folder: "
        echo "Cloning: "
        git clone "$1" "$folderName"
    fi

    echo Installing dependencies for "$folderName"

    cd /"$rootCustomNodes/$folderName"
    pip install -r requirements.txt
    cd $rootComfyUI
}


# Installing ComfyUI Manager:
git_get_nodes "https://github.com/ltdrdata/ComfyUI-Manager" "comfyui-manager"
# cd $rootCustomNodes
# git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
# pip install -r requirements.txt


# Installing Lora manager:
git_get_nodes "https://github.com/willmiao/ComfyUI-Lora-Manager.git" "ComfyUI-Lora-Manager"
# cd $rootCustomNodes
# git clone https://github.com/willmiao/ComfyUI-Lora-Manager.git
# cd ComfyUI-Lora-Manager
# pip install -r requirements.txt


git_get_nodes "git clone https://github.com/VraethrDalkr/ComfyUI-TripleKSampler.git" "ComfyUI-TripleKSampler"


cd $rootComfyUI
printf "ComfyUI: Staring ComfyUI"
python3 main.py --listen 0.0.0.0 --port 3001

printf "Application ready!"
# git clone https://github.com/comfyanonymous/ComfyUI.git
sleep infinity