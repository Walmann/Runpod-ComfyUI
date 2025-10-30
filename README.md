
# PORTS
| PORT  | App |
| ------| ------- |
| 3001  | ComfyUI |
| 3923  | CopyParty |


# Script Descripton
| Script  | Description |
| ------| ------- |
| installComfyUI.sh     | Installs and runs Comfyui. This also installs "Default nodes" from installNodes |
| installCopyParty.sh   | Installs CopyParty. You then need to run startCopyParty.su to run it|
| installModels.sh      | Tool to install models, for easy startup. |
| installNodes.sh       | Tool to install nodes, for easy startup.  |
| closeUpShop.sh        | Tool to backup data when closing a pod.   |


python 3.11
cuda 12.8.1
torch 2.8.0




# Based on: 
https://github.com/ashleykleynhans/runpod-worker-a1111
https://github.com/ashleykleynhans/comfyui-docker/
