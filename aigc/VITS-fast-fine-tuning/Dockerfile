FROM slpcat/python:3.10.11-bullseye

RUN \
    apt-get update -y && \
    apt-get install -y libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs pkg-config libcairo2-dev libreadline8 gcc ffmpeg
  apt-get install gfortran
 apt-get install libopenblas-dev liblapack-dev libatlas-base-dev libblas-dev

RUN useradd -s /bin/bash -d /app riffusion \
    && mkdir -p /app/ \
    && chown -R riffusion:riffusion /app
USER riffusion
RUN \
    cd /app \
https://github.com/Plachtaa/VITS-fast-fine-tuning.git
    && git clone https://github.com/riffusion/riffusion \
    && cd riffusion \
    && pip3 install -r requirements.txt
pip install imageio==2.4.1
pip install moviepy
    #chmod -R 755 extensions

WORKDIR /app/riffusion

#python -m riffusion.server --host 0.0.0.0 --port 3013
CMD ["python3", "-m", "riffusion.server", "--host", "0.0.0.0", "--port", "3013"]
