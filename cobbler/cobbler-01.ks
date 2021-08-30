#version=DEVEL

install
text
url --url="http://192.168.0.1/cobbler/ks_mirror/CentOS-6.8-x86_64/"
lang en_US.UTF-8
keyboard us

#network --bootproto=dhcp --device=eth0 --onboot=on


#network --onboot no --device eth0 --bootproto dhcp --noipv6
#network --onboot no --device eth1 --bootproto dhcp --noipv6
#network --onboot yes --device eth2 --bootproto dhcp --noipv6
rootpw  --iscrypted $1$Yd0IAAMq$41vUScq5aYt2d1k7Ak7Na/
firewall --service=ssh
authconfig --enableshadow --passalgo=sha512
selinux --disabled
timezone --utc Asia/Shanghai
skipx

bootloader --location=mbr --append="ipv6.disable=1 intel_iommu=on"

# The following is the partition information you requested
# Note that any partitions you deleted are not expressed
# here so unless you clear all partitions first, this is
# not guaranteed to work
#clearpart --linux --drives=sda,sdb

zerombr
clearpart --all --initlabel

part /boot --fstype=ext4 --asprimary --size=1000 --ondisk sda
#part swap --asprimary --size=4096 --ondisk sda
part / --fstype=ext4 --asprimary --size=100000 --ondisk sda
part /tol --fstype=ext4 --grow --size=200 --ondisk sda

reboot

%pre
set -x -v
exec 1>/tmp/ks-pre.log 2>&1

# Once root's homedir is there, copy over the log.
while : ; do
    sleep 10
    if [ -d /mnt/sysimage/root ]; then
        cp /tmp/ks-pre.log /mnt/sysimage/root/
        logger "Copied %pre section log to system"
        break
    fi
done &


curl "http://192.168.0.1/cblr/svc/op/trig/mode/pre/profile/CentOS-6.8-x86_64" -o /dev/null


%end

%packages
@base
@core
@development

%post

set -x -v
exec 1>/root/ks-post.log 2>&1

# Error: no snippet data for post_init_command

# Enable post-install boot notification

# Start final steps

curl "http://192.168.0.1/cblr/svc/op/ks/profile/CentOS-6.8-x86_64" -o /root/cobbler.ks
curl "http://192.168.0.1/cblr/svc/op/trig/mode/post/profile/CentOS-6.8-x86_64" -o /dev/null

%end

%post

rpm -ih http://192.168.0.1/kernel-lt-devel-4.4.185-1.el7.elrepo.x86_64.rpm
rpm -ih http://192.168.0.1/kernel-lt-4.4.185-1.el7.elrepo.x86_64.rpm
sed -i 's/default=1/default=0/g' /etc/grub.conf

%end
