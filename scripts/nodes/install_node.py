import sys
from configparser import ConfigParser
from pathlib import Path
from git import Repo

# # Legg til scripts/ i sys.path (2 nivåer opp fra install_node.py)
# scripts_dir = Path(__file__).parent.parent
# sys.path.insert(0, str(scripts_dir))


from settings import config
from common import git_installer, pipInstall_file, log
from nodes import node_registry


### Install nodes
def Install_node(settings: ConfigParser, node_info:str):

    log("Installing node ${node[0]}")
    repo: Repo = git_installer.install(repo=node_info[1], dir=Path(settings["Paths"]["COMFYUI_NODES_DIR"]))

    log("Installing requirements for node: ${node[0]}")
    requirements = Path(repo.working_dir, "\\requirements.txt")
    pipInstall_file(req_file=requirements)
    pass

def Install_nodes(settings:ConfigParser, nodes: list):
    for node in nodes:
        Install_node(settings=settings, node_info=node)
    pass

def get_repo_section(section: str):
    r = node_registry()
    nodelist = []
    for key in r[section]:
        nodelist.append([key, r[section][key]])
    return nodelist


# For testing this script:
if __name__ == "__main__":
    # Install_node(settings=config(), repo_url="https://github.com/ssitu/ComfyUI_UltimateSDUpscale")
    
    # Get list of repo URLs
    # t = get_repo_section("Default")

    # Install multiple nodes:
    node_list = get_repo_section("Default")
    setting = config()
    Install_nodes(settings=setting, nodes=node_list)

    pass