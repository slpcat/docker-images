#!/bin/sh

image=${1}

echo -n "Scala does execute a correct app... "
docker run --rm --volume "$PWD/tests/resources:/resources" "$image" \
  scala "/resources/correctExecution.scala" 2>&1 /dev/null
if [ "$?" -eq 0 ]; then
  echo "success"
else
  echo "failure"
  exit 1
fi

echo -n "Scala does not execute an incorrect app... "
docker run --rm --volume "$PWD/tests/resources:/resources" "$image" \
  scala "/resources/incorrectExecution.scala" 2>&1 /dev/null
if [ "$?" -eq 1 ]; then
  echo "success"
else
  echo "failure"
  exit 1
fi

exit 0
