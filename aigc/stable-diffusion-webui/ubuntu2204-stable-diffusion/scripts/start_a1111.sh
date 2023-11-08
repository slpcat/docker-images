#!/usr/bin/env bash
echo "Starting Stable Diffusion Web UI"
cd /workspace/stable-diffusion-webui
nohup ./webui.sh -f > /workspace/logs/webui.log 2>&1 &
echo "Stable Diffusion Web UI started"
echo "Log file: /workspace/logs/webui.log"
