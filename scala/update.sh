#!/bin/bash

set -eo pipefail

declare -a versions=(
    2.12.4
    2.12.3
    2.12.2
    2.12.1
    2.12.0
    2.11.12
    2.11.11
    2.11.10
    2.11.9
    2.11.8
    2.11.7
    2.11.6
    2.11.5
    2.11.4
    2.11.3
    2.11.2
    2.11.1
    2.11.0
    2.10.7
    2.10.6
    2.10.5
    2.10.4
    2.10.3
    2.10.2
)

generate_standard() {
  sed -e "s/<version>/$1/g" dockerfile/standard.template > "$1/Dockerfile"
}

generate_alpine() {
  cp -R base/alpine "$1/alpine"
  sed -e "s/<version>/$1/g" dockerfile/alpine.template > "$1/alpine/Dockerfile"
}

for version in "${versions[@]}"
do
  rm -rf "${version}"
  mkdir "${version}"
  
  generate_standard "${version}"
  generate_alpine "${version}"
done
