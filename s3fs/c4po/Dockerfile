FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y install openssh-server
RUN apt-get -y install automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config
RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git && \
    cd s3fs-fuse && \
    ./autogen.sh && \
    ./configure && \
    make && \
    make install

RUN mkdir -p /var/run/sshd

COPY entrypoint /
RUN chmod +x /entrypoint

# SSH username and password
ENV SFTP_USER=sftp
ENV SFTP_PASSWORD=changeme1

EXPOSE 22

ENTRYPOINT ["/entrypoint"]