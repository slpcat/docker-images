#FROM fabric8/java
FROM jolokia/java-jolokia:6

RUN curl -o /tmp/orion.zip http://mirrors.ibiblio.org/eclipse/orion/drops/R-8.0-201502161823/eclipse-orion-8.0-linux.gtk.x86_64.zip && \
    cd /opt && unzip /tmp/orion.zip && \
    rm -rf /tmp/orion.zip

RUN chmod +x /opt/eclipse/orion

EXPOSE 8080

WORKDIR /opt/eclipse

ADD  orion.conf /opt/eclipse/orion.conf
ADD  .gitconfig /root/.gitconfig

CMD ["/opt/eclipse/orion"]
