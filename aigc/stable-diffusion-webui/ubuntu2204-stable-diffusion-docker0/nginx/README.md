## Automatic1111 Stable Diffusion WebUI, Kohya SS and ComfyUI

### Version 3.4.0 with SDXL support and ControlNet SDXL support

### Included in this Template

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
* Torch 2.0.1
* xformers 0.0.22
* sd_xl_base_1.0.safetensors
* sd_xl_refiner_1.0.safetensors
* sdxl_vae.safetensors
* inswapper_128.onnx
* [runpodctl](https://github.com/runpod/runpodctl)
* [croc](https://github.com/schollz/croc)
* [Application Manager](https://github.com/ashleykleynhans/app-manager)

### Ports

**NOTE:** The first time you create your container, the applications
will need to sync to the **/workspace** directory.  This can take
a few minutes to complete.  The ports below will not be accessible
until such time as the syncing completes and the container logs
say **Container is READY!**.

| Connect Port | Internal Port | Description                   |
|--------------|---------------|-------------------------------|
| 3000         | 3001          | A1111 Stable Diffusion Web UI |
| 3010         | 3011          | Kohya_ss                      |
| 3020         | 3021          | ComfyUI                       |
| 6006         | 6066          | Tensorboard                   |
| 8000         | 8000          | Application Manager           |
| 8888         | 8888          | Jupyter Lab                   |

You can use the Application Manager to stop and start
the applications.  This can be useful for stopping the
A1111 Web UI if you want to train using Kohya_ss for example.

### Environment Variables

| Variable           | Description                                  | Default  |
|--------------------|----------------------------------------------|----------|
| JUPYTER_PASSWORD   | Password for Jupyter Lab                     | Jup1t3R! |
| DISABLE_AUTOLAUNCH | Disable Web UIs from launching automatically | enabled  |
| ENABLE_TENSORBOARD | Enables Tensorboard on port 6006             | enabled  |

## Logs

Stable Diffusion Web UI and Kohya SS both create log
files, and you can tail the log files instead of
killing the services to view the logs

| Application             | Log file                     |
|-------------------------|------------------------------|
| Stable Diffusion Web UI | /workspace/logs/webui.log    |
| Kohya SS                | /workspace/logs/kohya_ss.log |
| ComfyUI                 | /workspace/logs/comfyui.log  |

For example:

```bash
tail -f /workspace/logs/webui.log
```

### Jupyter Lab

If you wish to use the Jupyter lab, you must set
the **JUPYTER_PASSWORD** environment variable in the
Template Overrides configuration when deploying
your pod.

### General

Note that this does not work out of the box with
encrypted volumes!

This is a custom packaged template for Stable Diffusion
using the Automatic1111 Web UI, as well as the Dreambooth,
Deforum, ControlNet, ADetailer and roop extension repos.

It also contains the Kohya_ss Web UI and ComfyUI.

I do not maintain the code for any of these repos,
I just package everything together so that it is
easier for you to use.

If you need help with settings, etc. You can feel free
to ask me, but just keep in mind that I am not an expert
at Stable Diffusion! I'll try my best to help, but the
RunPod community or Automatic/Stable Diffusion communities
may be better at helping you.

### Changing launch parameters

You may be used to changing a different file for your
launch parameters. This template uses **webui-user.sh**,
which is located in the webui directory
(**/workspace/stable-diffusion-webui**) to manage the
launch flags such as **--xformers**. You can feel free
to edit this file, and then restart your pod via the
hamburger menu to get them to go into effect, or
alternatively just use **fuser -k 3001/tcp** and start
the **/workspace/stable-diffusion-webui/webui.sh -f**
script again.

### Using your own models

The best ways to get your models onto your pod is
by using **runpodctl** or **croc**.