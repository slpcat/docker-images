FROM slpcat/python:3.10.11-bullseye
nodejs

RUN \
    apt-get update -y && \
    apt-get install -y libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs pkg-config libcairo2-dev libreadline8 gcc ffmpeg

RUN useradd -s /bin/bash -d /app riffusion \
    && mkdir -p /app/ \
    && chown -R riffusion:riffusion /app
USER riffusion
RUN \
    cd /app \
    && git clone https://github.com/riffusion/riffusion-app \
    && cd riffusion-app \
    && pip install -r requirements.txt

WORKDIR /app/riffusion


#CMD ["bash", "-c", "./webui.sh"]
#python -m riffusion.server --host 127.0.0.1 --port 3013
