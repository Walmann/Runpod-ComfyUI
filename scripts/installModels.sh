#!/bin/bash


download_models(){
        dir=$1
        url=$2

        # Fjern eventuelle anførselstegn
        dir="${dir%\"}"
        dir="${dir#\"}"
        url="${url%\"}"
        url="${url#\"}"

        # Opprett mappen
        mkdir -p "$dir"

        # Hent filnavn fra url
        filename=$(basename "$url")

        if [ -e "$filename" ]; then
            echo 'File already exists' >&2
            exit 1
        else
            # Last ned filen
            echo "Laster ned: $url -> $dir/$filename"
            curl -L -C - --progress-bar "$url" -o "$dir/$filename"
        fi

}

# Download models
# echo "Downloading models"
cd "/workspace/ComfyUI/models"
# download_models "https://raw.githubusercontent.com/Walmann/Runpod-ComfyUI/refs/heads/main/scripts/models.txt"


menu_function() {
    echo "Choose model to download:"
    echo "1) Wan 2.2 14B I2V"
    echo "2) Wan 2.2 Animate"
    echo "3) Qwen Image Edit 2509"
    # echo "4) Qwen Image Edit"
    echo "5) ReActor Models"
    echo "6) Flux Kontext Dev"
    echo "7) Flux1 Dev (GGUF)"
    echo "8) Upscale models"
    echo "9) Impack Pack Models"
    echo "10) Wan 2.2 14B T2V"
    echo "11) SDXL Realviz"


    read -p "Skriv inn nummer: " choice

    case $choice in
        1)
            echo            "Downloading Wan2.2 14B I2V"
            download_models "diffusion_models/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_high_noise_14B_fp8_scaled.safetensors" 
            download_models "diffusion_models/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/diffusion_models/wan2.2_i2v_low_noise_14B_fp8_scaled.safetensors"
            download_models "text_encoders" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
            download_models "vae" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"
            download_models "loras/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
            download_models "loras/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"
            ;;
        2)
            echo            "Downloading Wan2.2 Animate"
            download_models "diffusion_models/WAN2.2Animate" "https://huggingface.co/Kijai/WanVideo_comfy_fp8_scaled/resolve/main/Wan22Animate/Wan2_2-Animate-14B_fp8_e4m3fn_scaled_KJ.safetensors"
            download_models "loras/WAN2.2Animate" "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/Lightx2v/lightx2v_I2V_14B_480p_cfg_step_distill_rank64_bf16.safetensors"
            download_models "loras/WAN2.2Animate" "https://huggingface.co/Kijai/WanVideo_comfy/resolve/main/LoRAs/Wan22_relight/WanAnimate_relight_lora_fp16.safetensors"
            download_models "text_encoders" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
            download_models "vae" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"
            download_models "clip_vision/WAN2.2Animate" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/clip_vision/clip_vision_h.safetensors"
            download_models "unet/WAN2.2Animate" "https://huggingface.co/QuantStack/Wan2.2-Animate-14B-GGUF/resolve/main/Wan2.2-Animate-14B-Q8_0.gguf"
            ;;
        3)
            echo            "Downloading Qwen_image_edit_2509"
            download_models "diffusion_models/qwen2509" "https://huggingface.co/Comfy-Org/Qwen-Image-Edit_ComfyUI/resolve/main/split_files/diffusion_models/qwen_image_edit_2509_fp8_e4m3fn.safetensors"
            download_models "text_encoders" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/text_encoders/qwen_2.5_vl_7b_fp8_scaled.safetensors"
            download_models "vae" "https://huggingface.co/Comfy-Org/Qwen-Image_ComfyUI/resolve/main/split_files/vae/qwen_image_vae.safetensors"
            download_models "loras/qwen2509" "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-8steps-V1.0.safetensors"
            download_models "loras/qwen2509" "https://huggingface.co/lightx2v/Qwen-Image-Lightning/resolve/main/Qwen-Image-Edit-Lightning-4steps-V1.0.safetensors"
            download_models "loras/qwen2509" "https://huggingface.co/Danrisi/Lenovo_Qwen/resolve/main/lenovo.safetensors"
            download_models "loras/qwen2509" "https://huggingface.co/lovis93/next-scene-qwen-image-lora-2509/resolve/main/next-scene_lora_v1-3000.safetensors"
            ;;
        5)
            echo            "Downloading ReActor models"
            download_models "reswapper" "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/reswapper_256.onnx"
            download_models "insightface" "https://huggingface.co/datasets/Gourieff/ReActor/resolve/main/models/reswapper_256.onnx"
            ;;
        6)
            echo            "Downloading Flux Kontext Dev"
            download_models "vae/flux" "https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors"
            download_models "text_encoders" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/clip_l.safetensors"
            download_models "text_encoders" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors"
            download_models "diffusion_models/FluxKontextDev" "https://huggingface.co/Comfy-Org/flux1-kontext-dev_ComfyUI/resolve/main/split_files/diffusion_models/flux1-dev-kontext_fp8_scaled.safetensors"
            ;;
        7)
            echo            "Downloading Flux1 Dev (GGUF)"
            download_models "unet/Flux1Dev" "https://huggingface.co/city96/FLUX.1-dev-gguf/resolve/main/flux1-dev-Q8_0.gguf"
            download_models "text_encoders" "https://huggingface.co/comfyanonymous/flux_text_encoders/resolve/main/t5xxl_fp8_e4m3fn_scaled.safetensors"
            download_models "vae/flux" "https://huggingface.co/Comfy-Org/Lumina_Image_2.0_Repackaged/resolve/main/split_files/vae/ae.safetensors"
            
            ;;
        8)
            echo            "Downloading Upscale Models"
            download_models "ESRGAN" "https://huggingface.co/FacehugmanIII/4x_foolhardy_Remacri/resolve/main/4x_foolhardy_Remacri.pth"
            
            ;;
        9)
            echo            "Downloading Impact-Pack"
            download_models "sams" "https://dl.fbaipublicfiles.com/segment_anything/sam_vit_b_01ec64.pth"
            download_models "ultralytics/bbox" "https://huggingface.co/Bingsu/adetailer/resolve/main/face_yolov9c.pt"
            download_models "ultralytics/bbox" "https://huggingface.co/Bingsu/adetailer/resolve/main/person_yolov8s-seg.pt"
            download_models "ultralytics/bbox" "https://huggingface.co/Bingsu/adetailer/resolve/main/hand_yolov9c.pt"
            
            ;;
        10)
            echo            "Downloading Wan2.2 14B T2V"
            download_models "diffusion_models/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/blob/main/split_files/diffusion_models/wan2.2_t2v_high_noise_14B_fp8_scaled.safetensors"
            download_models "diffusion_models/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/blob/main/split_files/diffusion_models/wan2.2_t2v_low_noise_14B_fp8_scaled.safetensors"
            download_models "text_encoders" "https://huggingface.co/Comfy-Org/Wan_2.1_ComfyUI_repackaged/resolve/main/split_files/text_encoders/umt5_xxl_fp8_e4m3fn_scaled.safetensors"
            download_models "vae" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/vae/wan_2.1_vae.safetensors"
            download_models "loras/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_high_noise.safetensors"
            download_models "loras/WAN2.2" "https://huggingface.co/Comfy-Org/Wan_2.2_ComfyUI_Repackaged/resolve/main/split_files/loras/wan2.2_i2v_lightx2v_4steps_lora_v1_low_noise.safetensors"
            ;;
        11)
            echo            "Downloading Wan2.2 14B T2V"
            download_models "checkpoints/SDXL" "https://huggingface.co/SG161222/RealVisXL_V5.0/resolve/main/RealVisXL_V5.0_fp32.safetensors"
            ;;
        *)
            echo "Ugyldig valg"
            ;;
    esac
}



while true; do
    menu_function
done