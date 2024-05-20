FROM slpcat/golang-gvm AS build
MAINTAINER 若虚 <slpcat@qq.com>

#get source code
COPY hello.go /hello.go
COPY go_build.sh /go_build.sh

#set golang env
RUN \
    #go命令行会使用modules，而一点也不会去GOPATH目录下查找
    go env -w GO111MODULE="on" && \
    #设置GOPROXY代理
    go env -w GOPROXY="https://goproxy.cn,direct" && \
    #把哪些仓库看做是私有的仓库，这样的话，就可以跳过 proxy server 和校验检查,比如常用的Gitlab或Gitee，中间使用逗号分隔
    go env -w GOPRIVATE="*.gitlab.com,*.gitee.com" && \
    #go mod vendor用于验证包的有效性
    go env -w GOSUMDB="sum.golang.google.cn" && \
    #使用GONOSUMDB这个环境变量来设置不做校验的代码仓库， 它可以设置多个匹配路径，用逗号相隔
    #go env -w GONOSUMDB="*.corp.example.com,rsc.io/private" && \

    go env -w GOARCH="amd64" && \
    go env -w GOOS="linux"

    #go env -w CC="clang"
    #go env -w CXX="clang++"
    #go env -w CGO_ENABLED="1"
    #go env -w GOMOD="/dev/null"
    #go env -w CGO_CFLAGS="-g -O2"
    #go env -w CGO_CPPFLAGS=""
    #go env -w CGO_CXXFLAGS="-g -O2"
    #go env -w CGO_FFLAGS="-g -O2"
    #go env -w CGO_LDFLAGS="-g -O2"

#compile
RUN \
    /go_build.sh

#build runtime 
FROM scratch
MAINTAINER 若虚 <slpcat@qq.com>

COPY --from=build /hello /hello

EXPOSE 8080
CMD ["./hello"]
