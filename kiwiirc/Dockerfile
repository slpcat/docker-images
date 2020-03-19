FROM  fedora:21

MAINTAINER fabric8.io <fabric8@googlegroups.com>

RUN yum install -y npm git

RUN useradd kiwi
USER kiwi
WORKDIR /home/kiwi

RUN git clone https://github.com/prawnsalad/KiwiIRC.git && cd KiwiIRC && npm install

ADD config.js /etc/kiwiirc/

RUN ./KiwiIRC/kiwi build

CMD ./KiwiIRC/kiwi -f start

