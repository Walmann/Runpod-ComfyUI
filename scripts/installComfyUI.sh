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
pip install opencv-python requests runpod==1.7.7 huggingface_hub huggingface_hub[cli]



# git clone --progress "https://github.com/comfyanonymous/ComfyUI"     
echo "ComfyUI: Entering Dir"
cd $rootComfyUI
echo "ComfyUI: Installing requirements"
pip install -r requirements.txt   | grep -v 'already satisfied'


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

    cd "$rootCustomNodes/$folderName"
    pip install -r requirements.txt  | grep -v 'already satisfied'
    cd $rootComfyUI
}


# Installing ComfyUI Manager:
git_get_nodes "https://github.com/ltdrdata/ComfyUI-Manager" "comfyui-manager"
# cd $rootCustomNodes
# git clone https://github.com/ltdrdata/ComfyUI-Manager comfyui-manager
# pip install -r requirements.txt


# Installing Lora manager:
# git_get_nodes "https://github.com/willmiao/ComfyUI-Lora-Manager.git" "ComfyUI-Lora-Manager"
# cd $rootCustomNodes
# git clone https://github.com/willmiao/ComfyUI-Lora-Manager.git
# cd ComfyUI-Lora-Manager
# pip install -r requirements.txt

# Install model manager.
git_get_nodes "https://github.com/hayden-fr/ComfyUI-Model-Manager.git" "ComfyUI-Model-Manager"


git_get_nodes "https://github.com/VraethrDalkr/ComfyUI-TripleKSampler.git" "ComfyUI-TripleKSampler"
git_get_nodes "https://github.com/kijai/ComfyUI-WanVideoWrapper" "ComfyUI-WanVideoWrapper"
git_get_nodes "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite" "ComfyUI-VideoHelperSuite"




get_models(){
    local URL=$2
    local downloaddir=$1


    wget -q --show-progress --progress=dot:giga -nc -P ./$downloaddir $URL 
}

echo Setting Current dir to models folder
cd $rootModels

# Wan2.2 I2V
get_models "diffusion_models/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors" 
get_models "diffusion_models/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
get_models "text_encoders" https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors
get_models "vae" https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors
get_models "loras/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
get_models "loras/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"

# Qwen 2509
get_models "diffusion_models/qwen2509" "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors"
get_models "text_encoders" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
get_models "vae" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
get_models "loras/qwen2509" "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Lightning-4steps-V1.0.safetensors"




cd $rootComfyUI
printf "ComfyUI: Staring ComfyUI"
python3 main.py --listen 0.0.0.0 --port 3001

printf "Application ready!"
# git clone https://github.com/comfyanonymous/ComfyUI.git
sleep infinity