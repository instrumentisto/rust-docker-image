#!/bin/bash


runCmd() {
  (set -x; $@)
}


if [ -z "$IMAGE_OS" ]; then
  echo "error: No IMAGE_OS env var provided"
  exit 1
fi
if [ -z "$IMAGE_TAGS" ]; then
  echo "error: No $IMAGE_TAGS env var provided"
  exit 1
fi


set -e


fullVer=$(docker run --rm instrumentisto/rust:build rustc -V \
          | cut -d ' ' -f2 \
          | tr -d "\n ")
numVer=$(echo "$fullVer" | cut -d '-' -f1 | tr -d "\n ")

tags=$(printf "$IMAGE_TAGS" | sed "s/<full-ver>/$fullVer/g" \
                            | sed "s/<num-ver>/$numVer/g" \
                            | tr ',' "\n")
repos=$(printf "$IMAGE_REPOS" | tr ',' "\n")

for tag in $tags; do
  for repo in $repos; do
    runCmd \
      docker tag instrumentisto/rust:build $repo/instrumentisto/rust:$tag
    runCmd \
      docker push $repo/instrumentisto/rust:$tag
  done
done
