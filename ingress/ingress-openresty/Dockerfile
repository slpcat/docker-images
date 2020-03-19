#upstream https://github.com/meyskens/k8s-openresty-ingress
ARG ARCH
# Build go binary
FROM golang AS gobuild

COPY ./ /go/src/github.com/meyskens/k8s-openresty-ingress
WORKDIR /go/src/github.com/meyskens/k8s-openresty-ingress/controller

ARG GOARCH
ARG GOARM

RUN GOARCH=${GOARCH} GOARM=${GOARM} go build ./

# Set up deinitive image
ARG ARCH
FROM maartje/openresty:${ARCH}-1.13.6.1

# Add Dummy cert for dummy conf
RUN openssl req -new -newkey rsa:2048 -days 3650 -nodes -x509 \
       -subj '/CN=sni-support-required-for-valid-ssl' \
       -keyout /etc/ssl/resty-auto-ssl-fallback.key \
       -out /etc/ssl/resty-auto-ssl-fallback.crt

COPY --from=gobuild /go/src/github.com/meyskens/k8s-openresty-ingress/controller/controller /usr/local/bin/controller

COPY ./config/default/ /etc/nginx/

COPY ./template/ingress.tpl /etc/nginx/ingress.tpl
ENV OPENRESTY_TEMPLATEPATH=/etc/nginx/ingress.tpl
ENV OPENRESTY_INGRESSATH=/etc/nginx/sites/

EXPOSE 80
EXPOSE 443
CMD controller
