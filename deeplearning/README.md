1. host nvidia driver with CUDA 
   pkg nvidia-drivers,cuda-drivers
2. nvidia-docker runtime
3. kubernetes support
   --feature-gates=DevicePlugins=true
   kubectl create -f nvidia-device-plugin.yml
4. container CUDA Toolkit 
   docker image: nvidia/cuda
5. container applications and frameworks DIGITS, Caffe, and TensorFlow 
   docker image: nvidia/digits,tensorflow/tensorflow:r0.9-devel-gpu,
https://gitlab.com/nvidia/cuda
https://github.com/NVIDIA/nvidia-docker
https://docs.nvidia.com/cuda/index.html
https://developer.nvidia.com/cuda-downloads
https://developer.nvidia.com/cudnn
https://github.com/NVIDIA/k8s-device-plugin
https://devblogs.nvidia.com/nvidia-docker-gpu-server-application-deployment-made-easy/
https://github.com/Microsoft/CNTK/blob/master/Tools/docker/CNTK-GPU-Image/Dockerfile
