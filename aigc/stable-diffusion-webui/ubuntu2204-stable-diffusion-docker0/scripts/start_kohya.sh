echo "Starting Kohya_ss Web UI"
cd /workspace/kohya_ss
nohup ./gui.sh --listen 0.0.0.0 --server_port 3011 --headless > /workspace/logs/kohya_ss.log 2>&1 &
echo "Kohya_ss started"
echo "Log file: /workspace/logs/kohya_ss.log"
