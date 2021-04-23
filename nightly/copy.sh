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
  podman pull docker.io/rustlang/rust:nightly-$IMAGE_OS

ver=$(podman run --rm docker.io/rustlang/rust:nightly-$IMAGE_OS rustc -V \
      | cut -d ' ' -f4 \
      | tr -d "\n )")
tags=$(printf "$IMAGE_TAGS" | sed "s/<ver>/$ver/g" | tr ',' "\n")
repos=$(printf "$IMAGE_REPOS" | tr ',' "\n")

for tag in $tags; do
  for repo in $repos; do
    runCmd \
      skopeo copy --all "docker://docker.io/rustlang/rust:nightly-$IMAGE_OS" \
                        "docker://$repo/instrumentisto/rust:$tag"
  done
done
