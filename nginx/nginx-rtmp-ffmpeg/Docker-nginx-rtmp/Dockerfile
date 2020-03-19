FROM alpine:latest
MAINTAINER Kukielka <kukielka58@gmail.com>

RUN	apk update		&&	\
	apk add				\
		openssl			\
		libstdc++		\
		ca-certificates		\
		pcre			\
		ffmpeg

ADD	nginx.tar.gz /opt/
ADD	nginx.conf /opt/nginx/conf/nginx.conf

EXPOSE 1935
EXPOSE 8080

CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]
