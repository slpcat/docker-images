Host OS prepare:
Debian, Ubuntu
apt-get -y install linux-headers-$(uname -r)
CentOS, RHEL, Fedora, Amazon Linux
yum -y install kernel-devel-$(uname -r)

docker run -i -t -v /var/run/docker.sock:/host/var/run/docker.sock -v /dev:/host/dev -v /proc:/host/proc:ro -v /boot:/host/boot:ro -v /lib/modules:/host/lib/modules:ro -v /usr:/host/usr:ro --privileged slpcat/sysdig
