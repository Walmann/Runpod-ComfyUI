from common.log import log
from common import pipInstall


def runpod_comfyui():
    log("Installing requirements for RUNPOD-COMFYUI")
    requirements = [
        "GitPython",
        "tqdm",
        "aiohttp",
        
    ]
    pipInstall(requirements)