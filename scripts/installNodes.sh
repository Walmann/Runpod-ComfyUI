#!/bin/bash

install_general_node(){
    repo_url=$1
    folderName=$2
    
    printf "\n\n\n\n Installing $folderName:"

    if [ -d "$folderName" ]; then
        echo "[$folderName] already exists, Skipping."
    else
        git clone "$repo_url" "$folderName"
        
        cd "$folderName" || exit 1

        # Installer dependencies hvis requirements.txt finnes
        if [ -f "requirements.txt" ]; then
            echo "Installing dependencies for $folderName"
            pip install -r requirements.txt | grep -v 'already satisfied'
        else
            echo "No requirements.txt found for $folderName, skipping."
        fi
    fi
    cd $cdCustomNodes
}

download_model(){
    dir=$1
    url=$2
    
    mkdir -p "$dir"
    
    filename=$(basename "$url")
    
    # Last ned filen
    echo "Laster ned: $url -> $dir/$filename"
    curl -L -C - --progress-bar "$url" -o "$dir/$filename"

    # return $filename
}

install_my_default_nodes(){
    install_general_node "https://github.com/ltdrdata/ComfyUI-Manager" "comfyui-manager"
    install_general_node "https://github.com/ltdrdata/ComfyUI-Impact-Pack" "comfyui-impact-pack"
    install_general_node "https://github.com/ltdrdata/ComfyUI-Impact-Subpack" "ComfyUI-Impact-Subpack"
    install_general_node "https://github.com/hayden-fr/ComfyUI-Model-Manager.git" "ComfyUI-Model-Manager"
    install_general_node "https://github.com/VraethrDalkr/ComfyUI-TripleKSampler.git" "ComfyUI-TripleKSampler"
    install_general_node "https://github.com/rgthree/rgthree-comfy.git" "rgthree-comfy"
    install_general_node "https://github.com/Azornes/Comfyui-Resolution-Master.git" "Comfyui-Resolution-Master"
    install_general_node "https://github.com/Fannovel16/comfyui_controlnet_aux/" "comfyui_controlnet_aux"
    # install_general_node "https://github.com/rakki194/ComfyUI-ImageCompare.git" "ComfyUI-ImageCompare"
}



install_magicNodes(){
    cd $cdCustomNodes
    repo_url=$1
    folderName=$2
    
    install_general_node "https://github.com/1dZb1/MagicNodes" "MagicNodes"
    
    # Extra steps
    # Install negative lora
    mv "$folderName/models/LoRA/mg_7lambda_negative.safetensors" "../models/loras/magicNodes/"
    download_model "$cdModels/loras" "https://huggingface.co/DD32/mg_7lambda_negative/resolve/main/mg_7lambda_negative.safetensors"
    download_model "$cdCustomNodes/$folderName/depth-anything" "https://huggingface.co/depth-anything/Depth-Anything-V2-Large/resolve/main/depth_anything_v2_vitl.pth"
    download_model "$cdModels/clip_vision" "https://huggingface.co/laion/CLIP-ViT-H-14-laion2B-s32B-b79K/resolve/main/open_clip_model.safetensors"
    download_model "$cdModels/controlnet" "https://huggingface.co/lllyasviel/sd_control_collection/resolve/main/diffusers_xl_depth_full.safetensors"

    # Install sageAttention
    pip install git+https://github.com/thu-ml/SageAttention
    
    cd $cdCustomNodes
}

install_wan_animate_nodes(){
    install_general_node "https://github.com/Fannovel16/comfyui_controlnet_aux/" "comfyui_controlnet_aux"
    install_general_node "https://github.com/kijai/ComfyUI-KJNodes" "ComfyUI-KJNodes"
    install_general_node "https://github.com/kijai/ComfyUI-segment-anything-2" "ComfyUI-segment-anything-2"
}

install_VideoNodes(){
    install_wan_animate_nodes
    install_general_node "https://github.com/kijai/ComfyUI-WanVideoWrapper" "ComfyUI-WanVideoWrapper"
    install_general_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite" "ComfyUI-VideoHelperSuite"
    install_general_node "https://github.com/stduhpf/ComfyUI-WanMoeKSampler.git" "ComfyUI-WanMoeKSampler"

    # Frame interpolation
    install_general_node "https://github.com/Fannovel16/ComfyUI-Frame-Interpolation" "ComfyUI-Frame-Interpolation"
    cd "ComfyUI-Frame-Interpolation"
    python3 install.py


    cd $cdCustomNodes
}

install_MMAudio(){
    install_general_node "https://github.com/kijai/ComfyUI-MMAudio" "ComfyUI-MMAudio"
    
    download_model "$cdModels/mmaudio" "https://huggingface.co/Kijai/MMAudio_safetensors/resolve/main/mmaudio_large_44k_v2_fp16.safetensors"
    download_model "$cdModels/mmaudio" "https://huggingface.co/Kijai/MMAudio_safetensors/resolve/main/mmaudio_synchformer_fp16.safetensors"
    download_model "$cdModels/mmaudio" "https://huggingface.co/Kijai/MMAudio_safetensors/resolve/main/mmaudio_vae_44k_fp16.safetensors"
    download_model "$cdModels/mmaudio" "https://huggingface.co/Kijai/MMAudio_safetensors/resolve/main/apple_DFN5B-CLIP-ViT-H-14-384_fp16.safetensors"
    
    
}

install_JoyCaptions(){
    cd $cdCustomNodes
    
    install_general_node "https://github.com/1038lab/ComfyUI-JoyCaption.git" "ComfyUI-JoyCaption"
    
    # Extra steps
    # Install GGUF models
    cd "ComfyUI-JoyCaption/"
    python llama_cpp_install/llama_cpp_install.py
    
    cd $cdCustomNodes
}

install_reactor(){
    cd $cdCustomNodes
    
    install_general_node "https://github.com/Gourieff/ComfyUI-ReActor" "ComfyUI-ReActor"
    
    # Extra steps
    download_model "reswapper" "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/reswapper_256.onnx"
    download_model "insightface" "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/reswapper_256.onnx"
    
    cd "ComfyUI-ReActor"
    python3 install.py

    printf 'from transformers import pipeline
from PIL import Image
import io
import logging
import os
import comfy.model_management as model_management
from reactor_utils import download
from scripts.reactor_logger import logger

MODEL_EXISTS = False

def ensure_nsfw_model(nsfwdet_model_path):
    """Download NSFW detection model if it doesn't exist"""
    global MODEL_EXISTS
    downloaded = 0
    nd_urls = [
        "https://huggingface.co/AdamCodd/vit-base-nsfw-detector/resolve/main/config.json",
        "https://huggingface.co/AdamCodd/vit-base-nsfw-detector/resolve/main/model.safetensors",
        "https://huggingface.co/AdamCodd/vit-base-nsfw-detector/resolve/main/preprocessor_config.json",
    ]
    for model_url in nd_urls:
        model_name = os.path.basename(model_url)
        model_path = os.path.join(nsfwdet_model_path, model_name)
        if not os.path.exists(model_path):
            if not os.path.exists(nsfwdet_model_path):
                os.makedirs(nsfwdet_model_path)
            download(model_url, model_path, model_name)
        if os.path.exists(model_path):
            downloaded += 1
    MODEL_EXISTS = True if downloaded == 3 else False
    return MODEL_EXISTS

SCORE = 0.96

logging.getLogger("transformers").setLevel(logging.ERROR)

def nsfw_image(img_data, model_path: str):
    return False (no filtering or overhead of checking)' >> 'scripts/reactor_sfw.py'


    cd $cdCustomNodes
}


cdCustomNodes="/workspace/ComfyUI/custom_nodes"
cdModels="/workspace/ComfyUI/models"
cd $cdCustomNodes
# download_models "https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/models.txt"

# Make sure we are in python enviorment: 
[[ "$VIRTUAL_ENV" == "" ]]; INVENV=$?
if [[ $INVENV -eq 1 ]];then
    echo "Not in python Venv. Now enabling Venv."
    source venv/bin/activate
else
    echo "Already in python Venv"
fi

menu_function() {
    echo "Choose model to download:"
    echo "1) My default nodes"
    echo "2) MagicNodes"
    echo "3) Wan 2.2 Animate nodes"
    echo "4) JoyCaption"
    echo "5) MMAudio"
    echo "6) Video Nodes"
    echo "7) Reactor Nodes + models"



    read -p "Skriv inn nummer: " -a choices  # -a = les inn som array

    for choice in "${choices[@]}"; do
        case $choice in
            1)
                echo "Installing my default nodes"
                install_my_default_nodes
                ;;
            2)
                echo "Installing MagicNodes"
                install_magicNodes
                ;;
            3)
                echo "Installing Wan 2.2 Animate nodes"
                install_wan_animate_nodes
                ;;
            4)
                echo "Installing JoyCaption"
                install_JoyCaptions
                ;;
            5)
                echo "Installing MMAudio"
                install_MMAudio
                ;;
            6)
                echo "Installing Video Nodes"
                install_VideoNodes
                ;;
            7)
                echo "Installing Reactor + models"
                install_reactor
                ;;
            *)
                echo "Ugyldig valg: $choice"
                ;;
        esac
    done
}



while true; do
    if [ "$1" == "default" ]; then
        echo "Installing default nodes."
        install_my_default_nodes
        break
    else
        menu_function
    fi
done