
from git import Repo
from pathlib import Path
from os.path import isdir


from .log import log
# from settings import Config

repo_dir: Repo = Repo

def _Clone(repo:str, dir:Path):
    r: Repo = Repo.clone_from(repo, dir)
    repo_dir = r
    return repo_dir

def _Update(dir:Path):
    r = Repo(dir)
    origin = r.remotes.origin
    origin.pull()
    log("Update complete")
    repo_dir = r
    return repo_dir


def install(repo:str, dir:Path):
    if isdir(dir):
        log("Found existing folder. Will now try to update.")
        return _Update(dir)
    else: 
        log("Repo not found. Cloning from Web")
        return _Clone(repo=repo, dir=Path(dir))
    # return repo_dir

# For testing this script: 
# install("https://github.com/ssitu/ComfyUI_UltimateSDUpscale", Path("./testing"))