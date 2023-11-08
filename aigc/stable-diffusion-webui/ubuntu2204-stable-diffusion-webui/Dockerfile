FROM nvidia/cuda:11.8.0-devel-ubuntu22.04

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y && \
    apt-get install -y vim-tiny net-tools iproute2 procps curl wget telnet less

RUN \
    apt-get update -y && \
    apt-get install -y libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs pkg-config libcairo2-dev libreadline8 gcc g++ ffmpeg python3-pip python3-venv

RUN useradd -s /bin/bash -d /app sd \
    && mkdir -p /app/ \
    && chown -R sd:sd /app
USER sd
RUN \
    cd /app \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui \
    && cd stable-diffusion-webui/extensions \
    && git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-locon \
    #&& git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Civitai-Helper \
    && git clone https://github.com/fkunn1326/openpose-editor \
    && git clone https://github.com/hnmr293/posex \
    && git clone https://github.com/zanllp/sd-webui-infinite-image-browsing.git \
    && git clone https://github.com/yfszzx/stable-diffusion-webui-images-browser \
    && git clone https://github.com/studyzy/sd-prompt-translator \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-rembg.git \
    && git clone https://github.com/Mikubill/sd-webui-controlnet \
    && git clone https://github.com/Bing-su/adetailer.git \
    #&& git clone https://github.com/civitai/sd_civitai_extension.git \
    #&& git clone https://github.com/Vetchems/sd-civitai-browser.git \
    && git clone https://github.com/camenduru/stable-diffusion-webui-huggingface \
    && git clone https://github.com/comfyanonymous/ComfyUI \
    #&& git clone https://github.com/toshiaki1729/stable-diffusion-webui-text2prompt.git \
    #&& git clone https://github.com/alexandersokol/sd-model-organizer.git \
    #&& git clone https://github.com/muerrilla/stable-diffusion-NPW.git \
    && git clone https://github.com/GeorgLegato/sd-webui-panorama-viewer.git \
    && git clone https://github.com/Kahsolt/stable-diffusion-webui-sonar.git \
    && git clone https://github.com/toshiaki1729/stable-diffusion-webui-dataset-tag-editor.git \
    && git clone https://github.com/CodeExplode/stable-diffusion-webui-embedding-editor.git \
    && git clone https://github.com/Maurdekye/training-picker.git \
    && git clone https://github.com/7eu7d7/DreamArtist-sd-webui-extension.git \
    && git clone https://github.com/Malisius/booru2prompt.git \
    && git clone https://github.com/Extraltodeus/multi-subject-render.git \
    && git clone https://github.com/pkuliyi2015/multidiffusion-upscaler-for-automatic1111 \
    && git clone https://github.com/opparco/stable-diffusion-webui-composable-lora \
    && git clone https://github.com/jexom/sd-webui-depth-lib \
    && git clone https://github.com/etherealxx/batchlinks-webui \
    && git clone https://github.com/thygate/stable-diffusion-webui-depthmap-script.git \
    #&& git clone https://github.com/dr413677671/PromptGallery-stable-diffusion-webui.git \
    && git clone https://github.com/rifeWithKaiju/model_preset_manager.git \
    && git clone https://github.com/tkalayci71/embedding-inspector.git \
    && git clone https://github.com/kex0/batch-face-swap.git \
    #&& git clone https://github.com/alemelis/sd-webui-ar.git \
    && git clone https://github.com/KohakuBlueleaf/a1111-sd-webui-lycoris \
    #&& git clone https://github.com/AIrjen/OneButtonPrompt \
    #&& git clone https://github.com/Physton/sd-webui-prompt-all-in-one \
    && git clone https://github.com/d8ahazard/sd_dreambooth_extension \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-aesthetic-gradients \
    && git clone https://github.com/deforum-art/deforum-for-automatic1111-webui \
    #&& git clone https://github.com/tsngo/stable-diffusion-webui-aesthetic-image-scorer \
    #&& git clone https://github.com/journey-ad/sd-webui-bilingual-localization \
    #&& git clone https://github.com/butaixianran/Stable-Diffusion-Webui-Prompt-Translator \
    && git clone https://github.com/fishslot/video_loopback_for_webui \
    && git clone https://github.com/Scholar01/sd-webui-mov2mov \
    #&& git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-promptgen \
    && git clone https://github.com/kohya-ss/sd-webui-additional-networks \
    #&& git clone https://github.com/Vetchems/sd-model-preview \
    #&& git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-nsfw-censor \
    #&& git clone https://github.com/Kahsolt/stable-diffusion-webui-prompt-travel \
    && git clone https://github.com/deforum-art/sd-webui-text2video.git \
    && git clone https://github.com/Coyote-A/ultimate-upscale-for-automatic1111.git \
    && git clone https://github.com/volotat/SD-CN-Animation \
    && git clone https://github.com/ilian6806/stable-diffusion-webui-state \
    && git clone https://github.com/nonnonstop/sd-webui-3d-open-pose-editor \
    && git clone https://github.com/jtydhr88/sd-3dmodel-loader.git \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui-pixelization.git \
    #&& git clone https://github.com/WildBanjos/DiffusionDefender \
    && git clone https://github.com/vladmandic/sd-extension-system-info \
    && git clone https://github.com/Zyin055/Config-Presets \
    && git clone https://github.com/camenduru/stable-diffusion-webui-artists-to-study
    #fix permissions
    #chmod -R 755 extensions

#pip install torch==2.0.1 torchvision --extra-index-url https://download.pytorch.org/whl/cu118

WORKDIR /app/stable-diffusion-webui
##cpu mode # Linux版
#export CUDA_VISIBLE_DEVICES=-1
#export COMMANDLINE_ARGS="--use-cpu all --no-half --precision full --skip-torch-cuda-test"

RUN \
    bash webui.sh --skip-torch-cuda-test  --xformers --no-download-sd-model || true

#reinstall torchvision
#RUN . ./venv/bin/activate \
#    && pip3 uninstall -y torchvision \
#    && pip3 install torchvision

CMD ["bash", "-c", "./webui.sh"]
