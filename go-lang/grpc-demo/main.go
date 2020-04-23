package main

import (
	"google.golang.org/grpc"
	"google.golang.org/grpc/reflection"
	proto "let_me_go/protobuf"
	"log"
	"net"
)

func main() {
	grpcServer := grpc.NewServer()
	// 注册grpcurl的reflection服务
	reflection.Register(grpcServer)
	proto.RegisterHelloServiceServer(grpcServer, new(proto.HelloServiceImpl))

	listen, e := net.Listen("tcp", "localhost:8888")

	if e != nil {
		log.Fatal(e)
	}

	grpcServer.Serve(listen)
}
