FROM slpcat/python:3.10.11-bullseye

RUN apt-get install -y libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs pkg-config libcairo2-dev libreadline8 gcc
RUN useradd -s /bin/bash -d /app sd \
    && mkdir -p /app/ \
    && chown -R sd:sd /app
USER sd
RUN \
    cd /app \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui \
    && cd stable-diffusion-webui/extensions \
    && git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-locon \
    && git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper \
    && git clone https://github.com/fkunn1326/openpose-editor \
    && git clone https://github.com/hnmr293/posex \
    && git clone https://github.com/Mikubill/sd-webui-controlnet \
    #https://github.com/d8ahazard/sd_dreambooth_extension
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-aesthetic-gradients \
    && git clone https://github.com/deforum-art/deforum-for-automatic1111-webui \
    && git clone https://github.com/tsngo/stable-diffusion-webui-aesthetic-image-scorer \
    && git clone https://github.com/journey-ad/sd-webui-bilingual-localization \
    && git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Prompt-Translator \
    && git clone https://github.com/fishslot/video_loopback_for_webui \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-promptgen \
    && git clone https://github.com/kohya-ss/sd-webui-additional-networks \
    && git clone https://github.com/Vetchems/sd-model-preview \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-nsfw-censor \
    && git clone https://github.com/Kahsolt/stable-diffusion-webui-prompt-travel \
    && git clone https://github.com/deforum-art/sd-webui-text2video.git \
    && git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git \
    && git clone https://github.com/volotat/SD-CN-Animation \
    && git clone https://github.com/ilian6806/stable-diffusion-webui-state \
    && git clone https://github.com/nonnonstop/sd-webui-3d-open-pose-editor \
    && git clone https://github.com/WildBanjos/DiffusionDefender \
    && git clone https://github.com/vladmandic/sd-extension-system-info \
    && git clone https://github.com/Zyin055/Config-Presets \
    && git clone https://github.com/camenduru/stable-diffusion-webui-artists-to-study

WORKDIR /app/stable-diffusion-webui
##cpu mode # Linux版
#export CUDA_VISIBLE_DEVICES=-1
#export COMMANDLINE_ARGS="--use-cpu all --no-half --precision full --skip-torch-cuda-test"

RUN \
    bash webui.sh --skip-torch-cuda-test  --xformers --no-download-sd-model || true

CMD ["bash", "-c", "./webui.sh"]
