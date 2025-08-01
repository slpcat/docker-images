################################################################################
# This Dockerfile was generated from the template at distribution/src/docker/Dockerfile
#
# Beginning of multi stage Dockerfile
################################################################################

################################################################################
# Build stage 0 `builder`:
# Extract Elasticsearch artifact
################################################################################

FROM slpcat/centos:7 AS builder

# `tini` is a tiny but valid init for containers. This is used to cleanly
# control how ES and any child processes are shut down.
#
# The tini GitHub page gives instructions for verifying the binary using
# gpg, but the keyservers are slow to return the key and this can fail the
# build. Instead, we check the binary against the published checksum.
RUN set -eux ; \
    tini_bin="" ; \
    case "$(arch)" in \
        aarch64) tini_bin='tini-arm64' ;; \
        x86_64)  tini_bin='tini-amd64' ;; \
        *) echo >&2 ; echo >&2 "Unsupported architecture $(arch)" ; echo >&2 ; exit 1 ;; \
    esac ; \
    curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v0.19.0/${tini_bin} ; \
    curl --retry 10 -S -L -O https://github.com/krallin/tini/releases/download/v0.19.0/${tini_bin}.sha256sum ; \
    sha256sum -c ${tini_bin}.sha256sum ; \
    rm ${tini_bin}.sha256sum ; \
    mv ${tini_bin} /bin/tini ; \
    chmod +x /bin/tini

RUN mkdir /usr/share/elasticsearch
WORKDIR /usr/share/elasticsearch

RUN curl --retry 10 -S -L --output /opt/elasticsearch.tar.gz https://artifacts-no-kpi.elastic.co/downloads/elasticsearch/elasticsearch-8.16.1-linux-$(arch).tar.gz

RUN tar -zxf /opt/elasticsearch.tar.gz --strip-components=1

# The distribution includes a `config` directory, no need to create it
COPY config/elasticsearch.yml config/
COPY config/log4j2.properties config/log4j2.docker.properties

#  1. Configure the distribution for Docker
#  2. Ensure directories are created. Most already are, but make sure
#  3. Apply correct permissions
#  4. Move the distribution's default logging config aside
#  5. Generate a docker logging config, to be used by default
#  6. Apply more correct permissions
#  7. The JDK's directories' permissions don't allow `java` to be executed under a different
#     group to the default. Fix this.
#  8. Remove write permissions from all files under `lib`, `bin`, `jdk` and `modules`
#  9. Ensure that there are no files with setuid or setgid, in order to mitigate "stackclash" attacks.
# 10. Ensure all files are world-readable by default. It should be possible to
#     examine the contents of the image under any UID:GID
RUN sed -i -e 's/ES_DISTRIBUTION_TYPE=tar/ES_DISTRIBUTION_TYPE=docker/' bin/elasticsearch-env && \
    mkdir -p config/jvm.options.d data logs plugins && \
    chmod 0775 config config/jvm.options.d data logs plugins && \
    mv config/log4j2.properties config/log4j2.file.properties && \
    mv config/log4j2.docker.properties config/log4j2.properties && \
    chmod 0660 config/elasticsearch.yml config/log4j2*.properties && \
    find ./jdk -type d -exec chmod 0755 {} + && \
    chmod -R a-w lib bin jdk modules && \
    find . -xdev -perm -4000 -exec chmod ug-s {} + && \
    find . -type f -exec chmod o+r {} +

################################################################################
# Build stage 1 (the actual Elasticsearch image):
#
# Copy elasticsearch from stage 0
# Add entrypoint
################################################################################

FROM slpcat/oraclejdk:17-bookworm

RUN \
    apt-get update && \
    apt-get install -y \
    zip unzip  && \
    apt-get clean all

ENV ELASTIC_CONTAINER true
RUN mkdir /usr/share/elasticsearch

WORKDIR /usr/share/elasticsearch

RUN groupadd -g 1000 elasticsearch && \
    useradd -u 1000 -g 1000 -G 0 -d /usr/share/elasticsearch elasticsearch && \
    chmod 0775 /usr/share/elasticsearch && \
    chown -R 1000:0 /usr/share/elasticsearch

COPY --from=builder --chown=1000:0 /usr/share/elasticsearch /usr/share/elasticsearch
COPY --from=builder --chown=0:0 /bin/tini /bin/tini

ENV PATH /usr/share/elasticsearch/bin:$PATH

COPY bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# 1. Sync the user and group permissions of /etc/passwd
# 2. Set correct permissions of the entrypoint
# 3. Ensure that there are no files with setuid or setgid, in order to mitigate "stackclash" attacks.
#    We've already run this in previous layers so it ought to be a no-op.
# 4. Replace OpenJDK's built-in CA certificate keystore with the one from the OS
#    vendor. The latter is superior in several ways.
#    REF: https://github.com/elastic/elasticsearch-docker/issues/171
RUN chmod g=u /etc/passwd && \
    chmod 0775 /usr/local/bin/docker-entrypoint.sh && \
    find / -xdev -perm -4000 -exec chmod ug-s {} +

EXPOSE 9200 9300

LABEL org.label-schema.build-date="2021-07-29T20:49:32.864135063Z" \
  org.label-schema.license="Elastic-License-2.0" \
  org.label-schema.name="Elasticsearch" \
  org.label-schema.schema-version="1.0" \
  org.label-schema.url="https://www.elastic.co/products/elasticsearch" \
  org.label-schema.usage="https://www.elastic.co/guide/en/elasticsearch/reference/index.html" \
  org.label-schema.vcs-ref="dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1" \
  org.label-schema.vcs-url="https://github.com/elastic/elasticsearch" \
  org.label-schema.vendor="Elastic" \
  org.label-schema.version="8.16.1" \
  org.opencontainers.image.created="2022-09-29T20:49:32.864135063Z" \
  org.opencontainers.image.documentation="https://www.elastic.co/guide/en/elasticsearch/reference/index.html" \
  org.opencontainers.image.licenses="Elastic-License-2.0" \
  org.opencontainers.image.revision="dd5a0a2acaa2045ff9624f3729fc8a6f40835aa1" \
  org.opencontainers.image.source="https://github.com/elastic/elasticsearch" \
  org.opencontainers.image.title="Elasticsearch" \
  org.opencontainers.image.url="https://www.elastic.co/products/elasticsearch" \
  org.opencontainers.image.vendor="Elastic" \
  org.opencontainers.image.version="8.16.1"

ENTRYPOINT ["/bin/tini", "--", "/usr/local/bin/docker-entrypoint.sh"]
# Dummy overridable parameter parsed by entrypoint
CMD ["eswrapper"]

################################################################################
# End of multi-stage Dockerfile
################################################################################

#install elasticsearch plugins
#RUN bin/elasticsearch-plugin install --batch repository-gcs
RUN bin/elasticsearch-plugin install --batch https://get.infini.cloud/elasticsearch/analysis-ik/8.16.1

#analysis-pinyin
#analysis-stconvert
#ingest-attachment
#ingest-geoip
#ingest-user-agent
#repository-bos
#repository-oss
#repository-hdfs
#elasticsearch-sql

#analysis-icu
#analysis-kuromoji
#analysis-smartcn
#store-smb
