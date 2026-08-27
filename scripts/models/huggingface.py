import huggingface_hub
from configparser import ConfigParser
from pathlib import Path

from .model_registry import model_registry
from common import log
download_DryRun = False

def hugginface_downloadModel(settings:ConfigParser):
    # TODO Create multi-Thread downloading.

    modelList = model_registry()
    for item in modelList:
        i = modelList[item]
        name = item
        repo = i["repo"]
        path = i["path"]
        subdir = i["subdir"]


        model_dir = str(Path(settings["Paths"]["COMFYUI_MODELS_DIR"],  subdir))


        dryRun_results = huggingface_hub.hf_hub_download(repo_id=repo, filename=path, local_dir=model_dir, dry_run=download_DryRun)
        log("DryRun results: ", "DEBUG")
        log(str(dryRun_results), "DEBUG")
        pass

    pass




if __name__ == "__main__":
    from model_registry import model_registry
    from settings import config
    download_DryRun = True
    hugginface_downloadModel(settings=config())
