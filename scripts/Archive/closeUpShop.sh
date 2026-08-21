
rootWorkspace="/workspace"
rootComfyUI="/workspace/ComfyUI"
rootUser="/workspace/ComfyUI/user/default"

$relativeComfyUI="./ComfyUI"

apt-get -qq install -y rsync 


# zip -r /workspace/closeUp.zip $rootComfyUI/output $rootUser/subgraphs $rootUser/workflows

cd $rootWorkspace
# rsync -R $relativeComfyUI/output ./myModels/ # After switch to VastAI, there is no need to change output folder.
rsync -R $relativeComfyUI/user/default/subgraphs ./myModels/subgraphs
rsync -R $relativeComfyUI/user/default/workflows ./myModels/workflows