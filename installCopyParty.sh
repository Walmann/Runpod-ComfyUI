#!/usr/bin/env bash

apt-get update && apt-get install tmux -y && tmux new-session -d -s copyparty 'curl -LsSf https://astral.sh/uv/install.sh | sh && source $HOME/.local/bin/env && uv tool run copyparty -p 8000 --allow-csrf' && tmux attach -t copyparty






# apt-get update
# apt-get install -y \
#     ffmpeg \
#     python3-pil

# cd workspace
# wget https://github.com/9001/copyparty/releases/latest/download/copyparty-sfx.py

# chmod 775 -R /workspace

# # python3 ./copyparty-sfx.py