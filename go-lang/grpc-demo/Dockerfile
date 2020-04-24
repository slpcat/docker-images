FROM slpcat/golang-gvm AS build
MAINTAINER 若虚 <slpcat@qq.com>

ENV CGO_ENABLED=1 \
    GO111MODULE=on \
    GOPROXY=https://goproxy.cn

COPY go_install.sh /
#compile

RUN \
    bash go_install.sh && \
    go get github.com/fullstorydev/grpcurl && \
    go install -a --ldflags '-extldflags -static' github.com/fullstorydev/grpcurl/cmd/grpcurl

#build runtime 
#FROM scratch
#MAINTAINER 若虚 <slpcat@qq.com>

#COPY --from=build /hello /hello

#EXPOSE 8080
#CMD ["./hello"]
