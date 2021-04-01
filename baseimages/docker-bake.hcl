group "default" {
	targets = ["alpine", "debian"]
}

target "alpine" {
    context = "./alpine-bake"
    dockerfile = "alpine.Dockerfile"
    tags = ["docker.io/slpcat/alpine:buildx-bake-hcl"]
    platforms = ["linux/amd64", "linux/arm64", "linux/arm/v6", "linux/arm/v7", "linux/s390x"]
    ## push to registry
    output = ["type=registry"]
    ## pull base image always
    pull = true
}

target "debian" {
    context = "./debian-bake"
    ## default: Dockerfile
    # dockerfile = "Dockerfile"  
    tags = ["docker.io/slpcat/debian:buildx-bake-hcl"]

    platforms = ["linux/amd64", "linux/arm64", "linux/arm/v6", "linux/arm/v7", "linux/s390x"]

    ## push to registry
    output = ["type=registry"]
    ## pull base image always
    pull = true
}

target "webapp-dev" {
	dockerfile = "Dockerfile.webapp"
	tags = ["docker.io/username/webapp"]
}

target "webapp-release" {
	inherits = ["webapp-dev"]
	platforms = ["linux/amd64", "linux/arm64"]
}

variable "TAG" {
	default = "latest"
}

group "default" {
	targets = ["webapp"]
}

target "webapp" {
	tags = ["docker.io/username/webapp:${TAG}"]
}
