#!/bin/bash

install_general_node(){
    repo_url=$2
    folderName=$1
    git clone "$repo_url" "$folderName"
        cd "$folderName" || exit 1

        # Installer dependencies hvis requirements.txt finnes
        if [ -f "requirements.txt" ]; then
            echo "Installing dependencies for $folderName"
            pip install -r requirements.txt | grep -v 'already satisfied'
        else
            echo "No requirements.txt found for $folderName, skipping."
        fi
    cd $cdCustomNodes
}

download_model(){
    dir=$1
    url=$2
    
    
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
    install_general_node "https://github.com/kijai/ComfyUI-WanVideoWrapper" "ComfyUI-WanVideoWrapper"
    install_general_node "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite" "ComfyUI-VideoHelperSuite"
    install_general_node "https://github.com/rgthree/rgthree-comfy.git" "rgthree-comfy"
    install_general_node "https://github.com/rakki194/ComfyUI-ImageCompare.git" "ComfyUI-ImageCompare"
}



install_magicNodes(){
    cd $cdCustomNodes
    repo_url=$1
    folderName=$2
    
    install_general_node "$folderName" "$repo_url" 
    
    # Extra steps
    # Install negative lora
    mv "$folderName/models/LoRA/mg_7lambda_negative.safetensors" "../models/loras/magicNodes/"

    download_model "$cdCustomNodes/$folderName/depth-anything/" "https://huggingface.co/depth-anything/Depth-Anything-V2-Large/resolve/main/depth_anything_v2_vitl.pth"
}

install_wan_animate_nodes(){
    install_general_node "https://github.com/Fannovel16/comfyui_controlnet_aux/" "comfyui_controlnet_aux"
    install_general_node "https://github.com/kijai/ComfyUI-KJNodes" "ComfyUI-KJNodes"
    install_general_node "https://github.com/kijai/ComfyUI-segment-anything-2" "ComfyUI-segment-anything-2"

}


# Download models
# echo "Downloading models"
cdCustomNodes="/workspace/ComfyUI/custom_nodes"
cd $cdCustomNodes
# download_models "https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/models.txt"


menu_function() {
    echo "Choose model to download:"
    echo "1) My default nodes"
    echo "2) MagicNodes"
    echo "3) Wan 2.2 Animate nodes"



    read -p "Skriv inn nummer: " choice

    case $choice in
        1)
            echo            "Installing my default nodes"
            install_my_default_nodes
            ;;
        2)
            echo            "Installing MagicNodes"
            install_magicNodes
            ;;
        3)
            echo            "Installing Wan 2.2 Animate nodes"
            install_wan_animate_nodes
            ;;
        *)
            echo "Ugyldig valg"
            ;;
    esac
}



while true; do
    if [[$1 == "default"] ]; then
        echo "Installing default nodes."
        install_my_default_nodes
        break 2
    else
    menu_function
    fi
done