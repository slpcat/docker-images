FROM golang:1.19-bullseye  as builder

ARG CONTROLLER_VERSION=v0.44.0
ARG CGO_ENABLED=0
ARG PKG=k8s.io/ingress-nginx
ARG TAG=v0.44.0
ARG COMMIT_SHA=f802554ccfadf828f7eb6d3f9a9333686706d613
ARG REPO_INFO=https://github.com/kubernetes/ingress-nginx

RUN \
    git clone https://github.com/kubernetes/ingress-nginx \
    && cd ingress-nginx \
    && git checkout controller-${CONTROLLER_VERSION} \
    && go build \
          -trimpath -ldflags="-buildid= -w -s \
          -X ${PKG}/version.RELEASE=${TAG} \
          -X ${PKG}/version.COMMIT=${COMMIT_SHA} \
          -X ${PKG}/version.REPO=${REPO_INFO}" \
          -o "/pkg/nginx-ingress-controller" "./cmd/nginx" \
    && go build \
          -trimpath -ldflags="-buildid= -w -s \
          -X ${PKG}/version.RELEASE=${TAG} \
          -X ${PKG}/version.COMMIT=${COMMIT_SHA} \
          -X ${PKG}/version.REPO=${REPO_INFO}" \
          -o "/pkg/dbg" "./cmd/dbg" \
    && go build \
          -trimpath -ldflags="-buildid= -w -s \
          -X ${PKG}/version.RELEASE=${TAG} \
          -X ${PKG}/version.COMMIT=${COMMIT_SHA} \
          -X ${PKG}/version.REPO=${REPO_INFO}" \
          -o "/pkg/wait-shutdown" "./cmd/waitshutdown"

FROM slpcat/tengine:v2.3.4-ingress-babassl

RUN apt-get install -y dumb-init libcap2-bin

WORKDIR  /etc/nginx

COPY --from=builder --chown=www-data:www-data /go/ingress-nginx/rootfs/etc /etc
COPY --from=builder --chown=www-data:www-data /go/ingress-nginx/rootfs/ingress-controller /ingress-controller
COPY --from=builder --chown=www-data:www-data /pkg /

# Fix permission during the build to avoid issues at runtime
# with volumes (custom templates)
RUN bash -xeu -c ' \
  writeDirs=( \
    /etc/ingress-controller \
    /etc/ingress-controller/ssl \
    /etc/ingress-controller/auth \
    /var/log \
    /var/log/nginx \
  ); \
  for dir in "${writeDirs[@]}"; do \
    mkdir -p ${dir}; \
    chown -R www-data.www-data ${dir}; \
  done'

RUN \
  setcap    cap_net_bind_service=+ep /nginx-ingress-controller \
  && setcap -v cap_net_bind_service=+ep /nginx-ingress-controller \
  && setcap    cap_net_bind_service=+ep /usr/local/nginx/sbin/nginx \
  && setcap -v cap_net_bind_service=+ep /usr/local/nginx/sbin/nginx

USER www-data

# Create symlinks to redirect nginx logs to stdout and stderr docker log collector
RUN  ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["/nginx-ingress-controller"]
