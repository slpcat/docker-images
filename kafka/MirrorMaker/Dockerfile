FROM confluentinc/cp-kafka
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
#RUN \
#    apt-get dist-upgrade -y


ENV \
    SRC_KAFKA_BROKERS="broker01:9092,broker02:9092" \
    SRC_KAFKA_USERNAME="" \
    SRC_KAFKA_PASSWORD="" \
    KAFKA_CONSUMER_ID="example-mirrormaker-group" \
    NUM_STREAMS="4" \
    DST_KAFKA_BROKERS="broker03:9092,broker04:9092" \
    DST_KAFKA_USERNAME="" \
    DST_KAFKA_PASSWORD="" \
    NUM_PRODUCERS="4" \
    KAFKA_CLIENT_ID="mirror_maker_producer" \
    TOPIC_LIST="topic1|topic2|topic3"

RUN mkdir -p /usr/src/ehmirror
COPY ./ehmirror/mirrorstart.sh /usr/src/ehmirror/mirrorstart.sh
WORKDIR /usr/src/ehmirror

ENTRYPOINT ["/usr/src/ehmirror/mirrorstart.sh"]
