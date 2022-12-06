#!/bin/bash


runCmd() {
  (set -x; $@)
}


if [ -z "$IMAGE" ]; then
  echo "error: No IMAGE env var provided"
  exit 1
fi
if [ -z "$IMAGE_FROM" ]; then
  echo "error: No IMAGE_FROM env var provided"
  exit 1
fi
if [ -z "$IMAGE_TAGS" ]; then
  echo "error: No IMAGE_TAGS env var provided"
  exit 1
fi


set -e


fullVer=$(docker run --rm $IMAGE_FROM rustc -V \
          | cut -d ' ' -f2 \
          | tr -d "\n ")
numVer=$(echo "$fullVer" | cut -d '-' -f1 | tr -d "\n ")

tags=$(printf "$IMAGE_TAGS" | sed "s/<full-ver>/$fullVer/g" \
                            | sed "s/<num-ver>/$numVer/g" \
                            | tr ',' "\n")

for tag in $tags; do
  runCmd \
    docker tag $IMAGE_FROM $IMAGE:$tag
  runCmd \
    docker push $IMAGE:$tag
done
