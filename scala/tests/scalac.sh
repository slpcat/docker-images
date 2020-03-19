#!/bin/sh

image=${1}

echo -n "Scalac does compile a correct class... "
docker run --rm --volume `pwd`/tests/resources:/resources ${image} \
  scalac /resources/CorrectCompilationClass.scala
if [ "$?" -eq 0 ]; then
  echo "success"
else
  echo "failure"
  exit 1
fi

echo -n "Scalac does not compile an incorrect class... "
docker run --rm --volume `pwd`/tests/resources:/resources ${image} \
  scalac /resources/IncorrectCompilationClass.scala
if [ "$?" -eq 1 ]; then
  echo "success"
else
  echo "failure"
  exit 1
fi

exit 0
