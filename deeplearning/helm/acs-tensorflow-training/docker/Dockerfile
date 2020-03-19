FROM tensorflow/tensorflow:1.5.0-devel-gpu
RUN mkdir /app
WORKDIR /app
RUN mkdir ./logs
COPY ./* /app/

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list
COPY pip.conf /root/.pip/pip.conf