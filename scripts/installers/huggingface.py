from huggingface_hub import hf_hub_download, login, auth_list, whoami
import os

from common import log


def huggingface():
    log("Authenticating with Huggingface", "DEBUG")
    login(os.getenv("HF_TOKEN"))
    log(str(whoami(token=os.getenv("HF_TOKEN"))), "DEBUG")
    log(str(auth_list()),"DEBUG")
    pass



if __name__ == "__main__":
    from dotenv import load_dotenv
    load_dotenv()
    huggingface()
