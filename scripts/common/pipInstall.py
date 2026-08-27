
import subprocess
import sys
from pathlib import Path

def pipInstall(modules:list):
    for e in modules:
        subprocess.check_call([sys.executable, "-m", "pip", "install", e])

def pipInstall_file(req_file:Path):
    reqs = []

    with open(req_file, "r") as file:
        for line in file.readlines():
            reqs.append(line)
    pipInstall(reqs)
    