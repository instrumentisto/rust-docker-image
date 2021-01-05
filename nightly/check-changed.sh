#!/bin/bash


if [ -z "$IMAGE_OS" ]; then
  echo "error: No IMAGE_OS env var provided"
  exit 1
fi


set -e


upstream=$(skopeo inspect \
                  --raw docker://docker.io/rustlang/rust:nightly-$IMAGE_OS \
           | jq -c '.')
echo "--> Upstream image manifests: $upstream"

latest=$((skopeo inspect \
                 --raw docker://ghcr.io/instrumentisto/rust:nightly-$IMAGE_OS \
          || echo '"none"') \
         | jq -c '.')
echo "--> Latest image manifests: $latest"

if [ "$upstream" != "$latest" ]; then
  echo "--> CHANGED"
fi
