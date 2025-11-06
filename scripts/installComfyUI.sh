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
    # Install some known missing packages: 
    echo "Installing pip packages: "
    pip install opencv-python           | grep -v 'already satisfied'
    pip install requests                | grep -v 'already satisfied'
    # pip install runpod==1.7.7           | grep -v 'already satisfied'
    pip install huggingface_hub         | grep -v 'already satisfied'
    pip install huggingface_hub[cli]    | grep -v 'already satisfied'
    pip install onnxruntime             | grep -v 'already satisfied'
    pip install onnxruntime-gpu         | grep -v 'already satisfied'
    pip install onnx                    | grep -v 'already satisfied'
    pip install sageattention           | grep -v 'already satisfied'
}


# git_get_nodes(){
#     local list_url="$1"
#     local tmp_nodelist="/tmp/node_list.txt"

#     # Download Node list
#     echo "Downloading nodes list from: $list_url"
#     curl -L --progress-bar "$list_url" -o "$tmp_nodelist"
#     if [[ $? -ne 0 ]]; then
#         echo "Could not download list."
#         return 1
#     fi


#     cd "$rootCustomNodes" || exit 1


#     # Gå gjennom hver linje i lista
#     while IFS= read -r line; do

#         cd "$rootCustomNodes" || exit 1
#         # Skip empty lines and comments
#         [[ -z "$line" || "$line" =~ ^# ]] && continue

#         eval set -- $line
#         repo_url=$1
#         folderName=$2

#         repo_url="${repo_url%\"}"
#         repo_url="${repo_url#\"}"
#         folderName="${folderName%\"}"
#         folderName="${folderName#\"}"

#         # # Sjekk om URLen er et git-repo eller en vanlig fil
#         # if [[ "$repo_url" =~ \.git$ ]]; then
#         # Git repository
#         if [ -d "$folderName" ]; then
#             echo "[$folderName] already exists, Skipping."
#             # cd "$folderName" || exit 1
#             # git pull
#         else
#             echo "[$folderName] not found, cloning now..."
#             git clone "$repo_url" "$folderName"
#             cd "$folderName" || exit 1

#             # Installer dependencies hvis requirements.txt finnes
#             if [ -f "requirements.txt" ]; then
#                 echo "Installing dependencies for $folderName"
#                 pip install -r requirements.txt | grep -v 'already satisfied'
#             else
#                 echo "No requirements.txt found for $folderName, skipping."
#             fi
#         fi


#     done < "$tmp_nodelist"

#     cd "$rootComfyUI" || exit 1
# }



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


border "ComfyUI: Staring ComfyUI"
cd $rootComfyUI

/workspace/venv/bin/python3 -m pip install sageattention
python3 main.py --use-sage-attention --lowvram --listen 0.0.0.0 --port 3001 --output-directory $rootWorkspace/myModels/Output
# python3 main.py --lowvram --listen 0.0.0.0 --port 3001 --output-directory $rootWorkspace/myModels/Output