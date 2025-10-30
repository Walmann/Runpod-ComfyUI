
# PORTS
| PORT  | App |
| ------| ------- |
| 3001  | ComfyUI |
| 3923  | CopyParty |


# Script Descripton
| Script  | Description |
| ------| ------- |
| installComfyUI.su     | Installs and runs Comfyui. This also installs "Default nodes" from installNodes |
| installCopyParty.su   | Installs CopyParty. You then need to run startCopyParty.su to run it|
| installModels.su      | Tool to install models, for easy startup. |
| installNodes.su       | Tool to install nodes, for easy startup.  |


python 3.11
cuda 12.8.1
torch 2.8.0




# Based on: 
https://github.com/ashleykleynhans/runpod-worker-a1111
https://github.com/ashleykleynhans/comfyui-docker/
