定制kubespray安装脚本
docker run --rm -it --net=host -v /root:/root  -v /var/run/docker.sock:/var/run/docker.sock -v /data/mycluster:/kubespray/inventory/mycluster slpcat/kubespray:v1.15.3 bash
