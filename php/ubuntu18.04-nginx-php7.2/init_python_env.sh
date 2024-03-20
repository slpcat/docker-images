#!/bin/bash
pip3 install grpcio-tools
python3 -m grpc_tools.protoc -I./Proto/grpc --python_out=./Proto/grpc --grpc_python_out=./Proto/grpc ./Proto/grpc/*.proto
