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



echo "Installing ComfyUI"
echo "ComfyUI: Cloning"

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
pip install \
    opencv-python \
    requests \
    runpod==1.7.7 \
    huggingface_hub \
    huggingface_hub[cli] \
    onnxruntime-gpu \
    onnx \
    sageattention \
    | grep -v 'already satisfied'
}



cd $rootComfyUI
echo "ComfyUI: Installing requirements"
pip install -r requirements.txt   | grep -v 'already satisfied'


git_get_nodes(){
    local repo_url="$1"
    local folderName="$2"

    cd "$rootCustomNodes" || exit 1

    if [ -d "$folderName/.git" ]; then
        echo "[$folderName] already exists, updating..."
        cd "$folderName" || exit 1
        git pull
    else
        echo "[$folderName] not found, cloning now..."
        git clone "$repo_url" "$folderName"
        cd "$folderName" || exit 1
    fi

    # Installer dependencies hvis requirements.txt finnes
    if [ -f "requirements.txt" ]; then
        echo "Installing dependencies for $folderName"
        pip install -r requirements.txt | grep -v 'already satisfied'
    else
        echo "No requirements.txt found for $folderName, skipping."
    fi

    cd "$rootComfyUI" || exit 1
}




download_models(){
local list_file="$1"

    if [[ ! -f "$list_file" ]]; then
        echo "Finner ikke fil: $list_file"
        return 1
    fi

    while IFS= read -r line; do
        # Hopp over tomme linjer og kommentarer
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Evaluer linja slik at anførselstegn håndteres
        eval set -- $line
        dir=$1
        url=$2

        # Fjern eventuelle anførselstegn
        dir="${dir%\"}"
        dir="${dir#\"}"
        url="${url%\"}"
        url="${url#\"}"

        # Opprett mappen
        mkdir -p "$dir"

        # Hent filnavn fra url
        filename=$(basename "$url")

        # Last ned filen
        echo "Laster ned: $url -> $dir/$filename"
        # curl -L --progress-bar "$url" -o "$dir/$filename"
    done < "$list_file"
}
# Install pip packages. Placed into function for faster debugging.
install_pip_packages()


# Download and install nodes
echo "Download and install nodes"
git_get_nodes("https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/nodes.txt")

# Download models
echo "Downloading models"
cd $rootModels
download_models("https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/models.txt")

cd $rootComfyUI
printf "ComfyUI: Staring ComfyUI"
python3 main.py --listen 0.0.0.0 --port 3001

printf "Application ready!"
# git clone https://github.com/comfyanonymous/ComfyUI.git
sleep infinity