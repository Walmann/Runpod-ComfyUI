


import configparser
import os
from pathlib import Path

# from common.log import log


def node_registry():
    config = configparser.ConfigParser(interpolation=configparser.ExtendedInterpolation())
    # Add sections and key-value pairs
    config.add_section('Default') 
    config.set("Default",'KJNodes', "https://github.com/kijai/ComfyUI-KJNodes.git")
    config.set("Default", "rgThree", "https://github.com/rgthree/rgthree-comfy.git")
    config.set("Default", "VideoHelperSuite", "https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git")
    
    
    config.add_section('MiniMaxH3') 
    config.set("MiniMaxH3", "Spectrum", "https://github.com/xmarre/ComfyUI-Spectrum-MiniMax-H3.git")
    config.set("MiniMaxH3", "MiniMaxRefsPack", "https://github.com/Hearmeman24/ComfyUI-MiniMaxRefPack.git")
    
    return config


if __name__ == "__main__":
    conf = node_registry()
    conf1 = conf["Default"]
    conf2 = conf1.get_sec
    for key in conf["Default"]:
        print(key)

pass