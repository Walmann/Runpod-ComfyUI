import configparser
import os
from pathlib import Path

from common.log import log


def config(isDebug = False):
    config = configparser.ConfigParser()
    # Add sections and key-value pairs
    # config.add_section('Default') 
    # config.set("Default",'REPO_URL', os.getenv("GIT_REPO_URL", "https://github.com/YOUR-REPO/setup.git"))
    # config.set("Default",'REPO_BRANCH', os.getenv("GIT_REPO_BRANCH", "main"))
    
    config.add_section('API_Key') 
    config.set("API_Key","HF_TOKEN", os.getenv("HF_TOKEN", ""))
    config.set("API_Key","CIVITAI_API_KEY", os.getenv("CIVITAI_API_KEY", "") )

    config.add_section('ComfyUI') 
    config.set("ComfyUI","Extra_Args", str(os.getenv("EXTRA_ARGS")))

    config.add_section("ModelDownload")
    config.set("ModelDownload", "MiniMaxH3", os.getenv("DlMiniMaxH3", "True"))
    
    config.add_section('Ports') 
    config.set("Ports","COMFY_PORT", os.getenv("COMFY_PORT", "8188"))
    config.set("Ports","OLLAMA_PORT", os.getenv("OLLAMA_PORT", "11434"))
    config.set("Ports","JUPYTER_PORT", os.getenv("JUPYTER_PORT", "8888"))


    # Set workspace dir. 
    workspaceDir = ""
    if os.getenv("WORKSPACE") == "":
        workspaceDir = str(Path("/workspace/runpod-slim"))
    else: 
        workspaceDir = os.getenv("WORKSPACE")


    config.add_section('Paths') 
    config.set("Paths","WORKSPACE",             workspaceDir)
    config.set("Paths","COMFYUI_DIR",           config.get("Paths", "WORKSPACE") +"\\ComfyUI")
    config.set("Paths","COMFYUI_MODELS_DIR",    config.get("Paths", "COMFYUI_DIR") +"\\models")
    config.set("Paths","COMFYUI_NODES_DIR",     config.get("Paths", "COMFYUI_DIR") + "\\custom_nodes",)
    config.set("Paths","REPO_DIR",              config.get("Paths", "WORKSPACE") + "\\RunpodComfy")
    
    # # Write the configuration to a file
    # log("Writing configuration to file", "DEBUG")
    # with open('config.ini', 'w') as configfile:
    #     config.write(configfile)

    if isDebug:
        config.set("Paths","WORKSPACE",str(Path("/workspace")))

    return config


    
# if __name__ == "__main__":
#     create_config()


# # ============================================================
# # CONFIGURATION — All values can be overridden via RunPod ENV
# # ============================================================

# REPO_URL = os.getenv("GIT_REPO_URL", "https://github.com/YOUR-REPO/setup.git")
# REPO_BRANCH = os.getenv("GIT_REPO_BRANCH", "main")

# # API Keys
# HF_TOKEN = os.getenv("HF_TOKEN", "")
# CIVITAI_API_KEY = os.getenv("CIVITAI_API_KEY", "") 

# # Ports — Also configured in RunPod web console
# COMFY_PORT = os.getenv("COMFY_PORT", "8188")
# OLLAMA_PORT = os.getenv("OLLAMA_PORT", "11434")
# JUPYTER_PORT = os.getenv("JUPYTER_PORT", "8888")

# # Paths
# WORKSPACE = Path("/workspace")
# COMFYUI_DIR = WORKSPACE / "ComfyUI"
# COMFYUI_MODELS_DIR = WORKSPACE / "ComfyUI/models"
# COMFYUI_NODES_DIR = WORKSPACE / "ComfyUI/custom_nodes"
# REPO_DIR = ""