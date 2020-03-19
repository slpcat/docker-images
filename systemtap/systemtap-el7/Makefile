.PHONY: doc build run default

IMAGE_NAME := modularitycontainers/systemtap
HELP_MD := ./help/help.md

default: run

doc:
	go-md2man -in=${HELP_MD} -out=./root/help.1

build: doc
	docker build --tag=$(IMAGE_NAME) .

run:
	atomic run $(IMAGE_NAME)

clean:
	docker rm systemtap
