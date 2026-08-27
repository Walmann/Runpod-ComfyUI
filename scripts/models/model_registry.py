
import configparser


def model_registry():
    models: dict = {
            "minimax_h3_audio_vae_fp32.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "vae/minimax_h3_audio_vae_fp32.safetensors",
                "subdir": "vae",
            },
            "minimax_h3_fl2v_lightx2v_turbo_4step_v0.1_comfy.safetensors": {
                "repo": "Kijai/MiniMax-H3_comfy/resolve",
                "path": "minimax_h3_fl2v_lightx2v_turbo_4step_v0.1_comfy.safetensors",
                "subdir": "loras",
            },
            "minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors": {
                "repo": "lightx2v/Minimax-h3-Turbo",
                "path": "minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors",
                "subdir": "loras",
            },
            "minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors": {
                "repo": "lightx2v/Minimax-h3-Turbo",
                "path": "minimax_h3_fl2v_turbo_8step_v1.0_comfyui_bf16.safetensors",
                "subdir": "loras",
            },
            "minimax_h3_fl2va_pruned_fp8_scaled.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "diffusion_models/minimax_h3_fl2va_pruned_fp8_scaled.safetensors",
                "subdir": "diffusion_models",
            },
            "minimax_h3_fl2va_pruned_int8_convrot.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "diffusion_models/minimax_h3_fl2va_pruned_int8_convrot.safetensors",
                "subdir": "diffusion_models",
            },
            "minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors": {
                "repo": "lightx2v/Minimax-h3-Turbo",
                "path": "minimax_h3_ref2v_turbo_4step_v0.1_comfyui_bf16.safetensors",
                "subdir": "loras",
            },
            "minimax_h3_ref2va_pruned_fp8_scaled.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "diffusion_models/minimax_h3_ref2va_pruned_fp8_scaled.safetensors",
                "subdir": "diffusion_models",
            },
            "minimax_h3_ref2va_pruned_int8_convrot.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "diffusion_models/minimax_h3_ref2va_pruned_int8_convrot.safetensors",
                "subdir": "diffusion_models",
            },
            "minimax_h3_video_vae_fp16.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "vae/minimax_h3_video_vae_fp16.safetensors",
                "subdir": "vae",
            },
            "qwen3vl_32b_minimax_h3_int8_convrot.safetensors": {
                "repo": "Comfy-Org/MiniMax-H3",
                "path": "text_encoders/qwen3vl_32b_minimax_h3_int8_convrot.safetensors",
                "subdir": "text_encoders",
            },
            "taeh3.safetensors": {
                "repo": "Hearmeman/comfyui-template-assets",
                "path": "vae_approx/taeh3.safetensors",
                "subdir": "vae_approx",
            },
        }
    return models


if __name__ == "__main__":
    # conf = model_registry()
    # conf1 = conf["Default"]
    # conf2 = conf1.get_sec
    # for key in conf["Default"]:
    #     print(key)

    pass
