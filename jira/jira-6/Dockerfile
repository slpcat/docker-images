# upstream from https://github.com/docker-atlassian/jira
# Install Atlassian Jira
# This is a trusted build based on the "base" image, but we also need postgresql
FROM linuxkonsult/postgres

MAINTAINER 若虚 slpcat@qq.com

ENV AppName jira-software
ENV AppVer 6.3.15
ENV Arch x64

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

# Fetch the files
#ADD http://www.atlassian.com/software/jira/downloads/binary/atlassian-$AppName-$AppVer-$Arch.bin /opt/
ADD atlassian-$AppName-$AppVer-$Arch.bin /opt
ADD ./install_cmds.sh /install_cmds.sh
ADD ./node.json /etc/chef/node.json
ADD ./response.varfile /opt/response.varfile
ADD ./init.sh /init.sh
ADD ./install_cmds.sh /install_cmds.sh

## Now Install Atlassian Jira
RUN /install_cmds.sh

# add patch
ADD atlassian-extras-2.2.2.jar /opt/atlassian/jira/atlassian-jira/WEB-INF/lib/atlassian-extras-2.2.2.jar
ADD atlassian-universal-plugin-manager-plugin-2.17.13.jar /opt/atlassian/jira/atlassian-jira/WEB-INF/atlassian-bundled-plugins/atlassian-universal-plugin-manager-plugin-2.17.13.jar

# Start the service
CMD ["sh", "/init.sh"]
EXPOSE 8080
