FROM slpcat/golang-gvm AS build
MAINTAINER 若虚 <slpcat@qq.com>

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn

#get source code
COPY hello.go /hello.go
COPY go_build.sh /go_build.sh

#compile
RUN \
    /go_build.sh

#build runtime 
FROM scratch
MAINTAINER 若虚 <slpcat@qq.com>

COPY --from=build /hello /hello

EXPOSE 8080
CMD ["./hello"]
