# Docker image for A1111 Stable Diffusion Web UI, Kohya_ss and ComfyUI

Now with SDXL support.

## Installs

* Ubuntu 22.04 LTS
* CUDA 11.8
* Python 3.10.12
* [Automatic1111 Stable Diffusion Web UI](
  https://github.com/AUTOMATIC1111/stable-diffusion-webui.git) 1.6.0
* [Dreambooth extension](
  https://github.com/d8ahazard/sd_dreambooth_extension) 1.0.14
* [Deforum extension](
  https://github.com/deforum-art/sd-webui-deforum)
* [ControlNet extension](
  https://github.com/Mikubill/sd-webui-controlnet) v1.1.411
* [After Detailer extension](
  https://github.com/Bing-su/adetailer) v23.10.1
* [Locon extension](
  https://github.com/ashleykleynhans/a1111-sd-webui-locon)
* [ReActor extension](https://github.com/Gourieff/sd-webui-reactor) (replaces roop)
* [Inpaint Anything extension](https://github.com/Uminosachi/sd-webui-inpaint-anything)
* [Infinite Image Browsing extension](https://github.com/zanllp/sd-webui-infinite-image-browsing)
* [Civitai extension](https://github.com/civitai/sd_civitai_extension)
* [Kohya_ss](https://github.com/bmaltais/kohya_ss) v22.1.0
* [ComfyUI](https://github.com/comfyanonymous/ComfyUI)
* [ComfyUI Manager](https://github.com/ltdrdata/ComfyUI-Manager.git)
* Torch 2.0.1
* xformers 0.0.22
* sd_xl_base_1.0.safetensors
* sd_xl_refiner_1.0.safetensors
* sdxl_vae.safetensors
* inswapper_128.onnx
* [runpodctl](https://github.com/runpod/runpodctl)
* [croc](https://github.com/schollz/croc)
* [rclone](https://rclone.org/)
* [Application Manager](https://github.com/ashleykleynhans/app-manager)

## Available on RunPod

This image is designed to work on [RunPod](https://runpod.io?ref=2xxro4sy).
You can use my custom [RunPod template](
https://runpod.io/gsc?template=ya6013lj5a&ref=2xxro4sy)
to launch it on RunPod.

## Building the Docker image

Since the Stable Diffusion models are pretty large, you will need at least
8GB of system memory (not GPU VRAM) to build this image.

The image **CAN** be built on a `t3a.large` AWS EC2 instance
which has 2 x vCPU and 8GB of system memory.  It **CANNOT** be built on
any instances with less memory, eg. `t3a.medium`.

```bash
# Clone the repo
git clone https://github.com/ashleykleynhans/stable-diffusion-docker.git

# Download the models
cd stable-diffusion-docker
wget https://huggingface.co/runwayml/stable-diffusion-v1-5/resolve/main/v1-5-pruned.safetensors
wget https://huggingface.co/stabilityai/sd-vae-ft-mse-original/resolve/main/vae-ft-mse-840000-ema-pruned.safetensors
wget https://huggingface.co/stabilityai/stable-diffusion-xl-base-1.0/resolve/main/sd_xl_base_1.0.safetensors
wget https://huggingface.co/stabilityai/stable-diffusion-xl-refiner-1.0/resolve/main/sd_xl_refiner_1.0.safetensors
wget https://huggingface.co/madebyollin/sdxl-vae-fp16-fix/resolve/main/sdxl_vae.safetensors

# Build and tag the image
docker build -t username/image-name:1.0.0 .

# Log in to Docker Hub
docker login

# Push the image to Docker Hub
docker push username/image-name:1.0.0
```

## Running Locally

### Install Nvidia CUDA Driver

- [Linux](https://docs.nvidia.com/cuda/cuda-installation-guide-linux/index.html)
- [Windows](https://docs.nvidia.com/cuda/cuda-installation-guide-microsoft-windows/index.html)

### Start the Docker container

```bash
docker run -d \
  --gpus all \
  -v /workspace \
  -p 3000:3001 \
  -p 3010:3011 \
  -p 3020:3021 \
  -p 6006:6066 \
  -p 8888:8888 \
  -e JUPYTER_PASSWORD=Jup1t3R! \
  -e ENABLE_TENSORBOARD=1 \
  ashleykza/stable-diffusion-webui:latest
```

You can obviously substitute the image name and tag with your own.

## Acknowledgements

1. [RunPod](https://runpod.io?ref=2xxro4sy) for providing most
   of the [container](https://github.com/runpod/containers) code.
2. [Bernard Maltais](https://github.com/bmaltais) (core developer of Kohya_ss)
   for assisting with optimizing the Docker image.

## Community and Contributing

Pull requests and issues on [GitHub](https://github.com/ashleykleynhans/stable-diffusion-docker)
are welcome. Bug fixes and new features are encouraged.

You can contact me and get help with deploying your container
to RunPod on the RunPod Discord Server below,
my username is **ashleyk**.

<a target="_blank" href="https://discord.gg/pJ3P2DbUUq">![Discord Banner 2](https://discordapp.com/api/guilds/912829806415085598/widget.png?style=banner2)</a>

## Appreciate my work?

<a href="https://www.buymeacoffee.com/ashleyk" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/v2/default-yellow.png" alt="Buy Me A Coffee" style="height: 60px !important;width: 217px !important;" ></a>
