FROM slpcat/python:3.10.11-bullseye

RUN \
    apt-get update -y && \
    apt-get install -y libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs pkg-config libcairo2-dev libreadline8 gcc g++

RUN useradd -s /bin/bash -d /app sd \
    && mkdir -p /app/ \
    && chown -R sd:sd /app

USER sd
RUN   pip3 install triton xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu118
RUN \
    cd /app && \
    git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && \
    git checkout master && \
    pip3 install -r requirements.txt

#ENV NVIDIA_DRIVER_CAPABILITIES=compute,utility NVIDIA_VISIBLE_DEVICES=all
ENV PYTHONPATH="${PYTHONPATH}:${PWD}" CLI_ARGS=""
EXPOSE 7860
CMD python -u main.py --listen --port 7860 ${CLI_ARGS}
