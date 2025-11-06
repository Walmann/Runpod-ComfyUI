#!/usr/bin/env bash
# set -e

border()
{
    # Creates a border around text
    title="| $1 |"
    edge=$(echo "$title" | sed 's/./-/g')
    echo "$edge"
    echo "$title"
    echo "$edge"
}



rootWorkspace="/workspace"
rootComfyUI="/workspace/ComfyUI"
rootModels="/workspace/ComfyUI/models"
rootCustomNodes="/workspace/ComfyUI/custom_nodes"
rootVenv="/workspace/venv/bin/activate"
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
    source $rootWorkspace/venv/bin/activate
    pyPath=$(which python3)
    border "Found Venv. Using that! Python path: $pyPath"
else
    border "Found no Virtual enviorment. Creating one now."
    python3 -m venv venv
    source $rootWorkspace/venv/bin/activate
    printf "Created Venv. Location: "
    which python
    python3 -V
fi


echo "Installing ComfyUI"
echo "Checking if $rootComfyUI exists."

if [ -d "$rootComfyUI" ]; then
    echo "Repo already exists, updating..."
    cd $rootComfyUI
    git pull
    cd $rootWorkspace
else
    cd $rootWorkspace
    echo "ComfyUI not found. Downloading. "
    git clone https://github.com/comfyanonymous/ComfyUI ComfyUI
fi

install_pip_packages(){
    pipInstall(){
        /workspace/venv/bin/python3 -m pip install $1           | grep -v 'already satisfied'    
    }
    # Install some known missing packages: 
    echo "Installing pip packages: "
    pipInstall opencv-python
    pipInstall requests
    pipInstall runpod==1.7.7
    pipInstall huggingface_hub
    pipInstall huggingface_hub[cli]
    pipInstall onnxruntime
    pipInstall onnxruntime-gpu
    pipInstall onnx
    # pipInstall sageattention
    
}





cd $rootComfyUI
echo "ComfyUI: Installing requirements"
source $rootVenv
pip install -r requirements.txt   | grep -v 'already satisfied'


# Install pip packages. Placed into function for faster debugging.
install_pip_packages

cd /


echo "Installing default nodes"
bash installNodes.sh "default"

border "To install models, open a WebTerminal and run installModels.sh (Found in root directory)\nTo install additional Nodes, open a WebTerminal and run installNodes.sh (Found in root directory)"


border "Configuring extra_model_paths.yaml"
cd $rootWorkspace
mkdir -p /myModels
cd /myModels
mkdir -p checkpoints text_encoders clip clip_vision configs controlnet diffusion_models unet embeddings loras upscale_models vae audio_encoders model_patches

cp /workspace/configs/extra_model_paths.yaml $rootComfyUI/


border "Installing Sage Attention 2.2.0"
pip install wheel
pip install sageattention==2.2.0 --no-build-isolation
pip install sageattention==2.2.0 --no-build-isolation



border "ComfyUI: Staring ComfyUI"
cd $rootComfyUI


python3 main.py --use-sage-attention --lowvram --listen 0.0.0.0 --port 3001 --output-directory $rootWorkspace/myModels/Output
# python3 main.py --lowvram --listen 0.0.0.0 --port 3001 --output-directory $rootWorkspace/myModels/Output