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

runCmd \
  podman pull docker.io/rust:$IMAGE_OS

fullVer=$(podman run --rm docker.io/rust:$IMAGE_OS rustc -V \
          | cut -d ' ' -f2 \
          | tr -d "\n )")
majorVer=$(printf "$fullVer" | cut -d '.' -f1)
minorVer="$majorVer.$(printf "$fullVer" | cut -d '.' -f2)"

tags=$(printf "$IMAGE_TAGS" | sed "s/<full-ver>/$fullVer/g" \
                            | sed "s/<minor-ver>/$minorVer/g" \
                            | sed "s/<major-ver>/$majorVer/g" \
                            | tr ',' "\n")
repos=$(printf "$IMAGE_REPOS" | tr ',' "\n")

for tag in $tags; do
  for repo in $repos; do
    runCmd \
      skopeo copy --all "docker://docker.io/rust:$IMAGE_OS" \
                        "docker://$repo/instrumentisto/rust:$tag"
  done
done
