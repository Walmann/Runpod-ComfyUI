
rootWorkspace="/workspace"
rootComfyUI="/workspace/ComfyUI"
rootUser="/workspace/ComfyUI/user/default"

$relativeComfyUI="./ComfyUI"

apt-get -qq install -y rsync 


# zip -r /workspace/closeUp.zip $rootComfyUI/output $rootUser/subgraphs $rootUser/workflows

cd $rootWorkspace
# rsync -R $relativeComfyUI/output ./myModels/ # No need for Output to be copied, right?
rsync -R ./myModels/subgraphs $relativeComfyUI/user/default/subgraphs 
rsync -R ./myModels/workflows $relativeComfyUI/user/default/workflows 