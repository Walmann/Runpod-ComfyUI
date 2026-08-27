#!/usr/bin/env python3
# import sys
# from pathlib import Path
# ROOT_DIR = Path(__file__).parent
# sys.path.insert(0, str(ROOT_DIR))


# from datetime import datetime

# from installers import runpod_comfyui
from common import log
from settings import config


from common import pipInstall


def main():
    log("Creating settings file")
    setting = config()

    log("Installing requirements for this app")
    requirements = [
        "GitPython",
        "tqdm",
        "aiohttp",
        "huggingface_hub"
        
    ]
    pipInstall(requirements)

    log("Starting ComfyUI setup")
    from start_app import startComfySetup
    startComfySetup(setting= setting)


if __name__ == "__main__":
    main()

