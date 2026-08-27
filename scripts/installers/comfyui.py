from common.log import log
from common import pipInstall, pipInstall_file
from common import git_installer
from settings import config
from git import Repo

from configparser import ConfigParser
from os.path import isdir
from os import chdir
from pathlib import Path


def comfyui(settings:ConfigParser):
    log("Installing ComfyUI requirements")
    comfyUI_Git_Repo = "https://github.com/Comfy-Org/ComfyUI"

    git_installer.install(repo=comfyUI_Git_Repo, dir=Path(settings.get("Paths", "COMFYUI_DIR")))


    log("Installing ComfyUI requirements")
    pipInstall_file(Path(settings.get("PATHS", "COMFYUI_DIR")) / "requirements.txt")

    pass