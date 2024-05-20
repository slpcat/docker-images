FROM slpcat/golang-gvm AS build
MAINTAINER 若虚 <slpcat@qq.com>

#get source code
COPY hello.go /hello.go
COPY go_build.sh /go_build.sh
RUN /go_build.sh

FROM scratch
MAINTAINER 若虚 <slpcat@qq.com>

COPY --from=build /hello /hello
EXPOSE 8080
CMD ["./hello"]
