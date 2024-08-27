FROM slpcat/ubuntu:systemd-jammy

MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
#install docker-ce
# Add Docker's official GPG key:
RUN \
    apt-get update && \
    apt-get install -y ca-certificates curl gnupg sudo && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
# Add the repository to Apt sources:
    echo \
      "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
       tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server  docker-ce wget vim-tiny htop iotop iftop net-tools tmux && \
    rm -rf /var/lib/apt/lists/

#add user
RUN \
   useradd -u 1000 -U -d /home/ubuntu -m  -s /bin/bash ubuntu && \
   usermod -a -G users,docker  ubuntu && \
   # set to foobar
   P="ubuntu123456" ; echo $P && echo "ubuntu:$P" | chpasswd && \
   sed -i '/^root/a\ubuntu    ALL=(ALL:ALL) NOPASSWD:ALL' /etc/sudoers

