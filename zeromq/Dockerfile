#upstream https://github.com/kulkarniamit/docker-zeromq-nodejs/blob/master/pyDockerfile
FROM ubuntu:16.04

RUN apt-get update && apt-get -y install libtool pkg-config build-essential \
                                         autoconf automake uuid-dev wget python
RUN wget -q https://github.com/zeromq/libzmq/releases/download/v4.2.2/zeromq-4.2.2.tar.gz
RUN tar -xzvf zeromq-4.2.2.tar.gz
WORKDIR /zeromq-4.2.2
RUN ./configure
RUN make install & ldconfig
RUN whereis python

WORKDIR /
ADD pythonserver.py /pythonserver.py
RUN chmod +x /pythonserver.py
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install pyzmq
CMD /usr/bin/python /pythonserver.py
