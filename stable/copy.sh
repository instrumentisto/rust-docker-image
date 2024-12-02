#!/bin/bash


runCmd() {
  (set -x; $@)
}


if [ -z "$IMAGE" ]; then
  echo "error: No IMAGE env var provided"
  exit 1
fi
if [ -z "$SOURCE_TAG" ]; then
  echo "error: No SOURCE_TAG env var provided"
  exit 1
fi
if [ -z "$IMAGE_TAGS" ]; then
  echo "error: No IMAGE_TAGS env var provided"
  exit 1
fi


set -e

runCmd \
  podman pull docker.io/rust:$SOURCE_TAG

fullVer=$(podman run --rm docker.io/rust:$SOURCE_TAG rustc -V \
          | cut -d ' ' -f2 \
          | tr -d "\n )")
majorVer=$(printf "$fullVer" | cut -d '.' -f1)
minorVer="$majorVer.$(printf "$fullVer" | cut -d '.' -f2)"

tags=$(printf "$IMAGE_TAGS" | sed "s/<full-ver>/$fullVer/g" \
                            | sed "s/<minor-ver>/$minorVer/g" \
                            | sed "s/<major-ver>/$majorVer/g" \
                            | tr ',' "\n")

for tag in $tags; do
  runCmd \
    skopeo copy --all "docker://docker.io/rust:$SOURCE_TAG" \
                      "docker://$IMAGE:$tag"
done
