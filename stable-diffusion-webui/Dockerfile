FROM slpcat/python:3.10.11-bullseye
#FROM pytorch/pytorch:1.13.1-cuda11.6-cudnn8-runtime


RUN apt-get  install -y  libgl1-mesa-glx  libglib2.0-dev
RUN useradd -s /bin/bash sd
USER sd
RUN \
    mkdir -p /app/ \
    && git clone https://github.com/AUTOMATIC1111/stable-diffusion-webui \
    && chown -R sd:sd /app 

WORKDIR /app/stable-diffusion-webui
##cpu mode # Linux版
#export CUDA_VISIBLE_DEVICES=-1
#export COMMANDLINE_ARGS="--use-cpu all --no-half --precision full --skip-torch-cuda-test"

RUN \
    bash webui.sh --skip-torch-cuda-test  --xformers --no-download-sd-model || true 
