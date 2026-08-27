#!/usr/bin/env python3
# import sys
# from pathlib import Path
# ROOT_DIR = Path(__file__).parent
# sys.path.insert(0, str(ROOT_DIR))


from datetime import datetime
import os
import subprocess
import configparser


import installers
from common import log
from settings import config
from nodes import node_registry, Install_nodes, get_repo_section
from models import huggingface


def startComfySetup(setting: configparser.ConfigParser):
    # log("Creating settings file")
    # setting = config()

    # log("Running all installers")
    # installers.runpod_comfyui() # Install requirements for this very script. 

    log("Creating args form Comfy", "DEBUG")
    args = ["python3", "main.py"]
    for a in setting["ComfyUI"]["Extra_Args"].split(","):
        args.append(a)
        pass


    log("Setting up Hugginface Downloader")
    installers.huggingface()

    log("Installing ComfyUI", "INFO")
    installers.comfyui(settings=setting)
    pass

    log("Installing Default nodes")
    nodes = get_repo_section("Default")
    Install_nodes(settings=setting, nodes=nodes)

    if os.getenv("MiniMaxH3"):
        log("Installing MiniMaxH3")
        nodes = get_repo_section("MiniMaxH3")
        Install_nodes(settings=setting, nodes=nodes)

        log("Downloading MiniMaxH3 models")
        huggingface.hugginface_downloadModel(settings=setting)
    
    log("Starting ComfyUI")
    log("Creating args form Comfy", "DEBUG")
    args = ["python3", "main.py"]
    for a in setting["ComfyUI"]["Extra_Args"].split(","):
        args.append(a)
        pass
    subprocess.run(args=args) 


if __name__ == "__main__":
    startComfySetup(setting= config())

