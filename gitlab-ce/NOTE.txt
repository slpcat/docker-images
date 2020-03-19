本镜像设计为生产环境使用。
基础系统使用debian9，设置本地化和中国时区，所有软件更新至最新。
软件包为gitlab-ce最新社区版，使用官方omnibus二进制包安装，apt使用清华大学源。
开放端口：HTTP 80， HTTPS 443，SSH 22。
数据卷：配置/etc/gitlab，数据/var/opt/gitlab，日志/var/log/gitlab。
其他详细配置请参考gitlab官网。

启动gitlab
docker run -it -p 10022:22 -p 10080:80 -p 10443:443 \
-v /data/gitlab/conf:/etc/gitlab -v /data/gitlab/data:/var/opt/gitlab \
-v /data/gitlab/log:/var/log/gitlab gitlab-ce:latest
如果报告权限错误，进入容器运行update-permissions修复权限

kubernets 部署示例
1. 指定节点node 创建3个本地pv
 /mnt/disks/gitlab-etc 存储类 local-gitlab-etc
 /mnt/disks/gitlab-log 存储类 local-gitlab-log
 /mnt/disks/gitlab-data 存储类 locale-gitlab-data
2. 创建pvc
3. 部署gitlab
4. 创建service提供外部访问

The latest docker guide can be found here: [GitLab Docker images](/doc/docker/README.md).
