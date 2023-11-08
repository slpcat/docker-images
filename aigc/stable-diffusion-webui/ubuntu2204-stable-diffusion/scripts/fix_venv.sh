#!/usr/bin/env bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <OLD_VENV> <NEW_VENV>"
  echo "   eg: $0 /home/ubuntu/test/venv /home/ubuntu/test/venv2"
  exit 1
fi

OLD_PATH=${1}
NEW_PATH=${2}

if [ ! -f ${NEW_PATH}/fixed ]; then
  cd ${NEW_PATH}/bin
  sed -i "s|${OLD_PATH}|${NEW_PATH}|g" *
  touch ${NEW_PATH}/fixed
fi