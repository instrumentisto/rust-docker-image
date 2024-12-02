#!/bin/bash

if [ -z "$IMAGE" ]; then
  echo "error: No IMAGE env var provided"
  exit 1
fi
if [ -z "$SOURCE_TAG" ]; then
  echo "error: No SOURCE_TAG env var provided"
  exit 1
fi


set -e


upstream=$(skopeo inspect --raw docker://docker.io/rust:$SOURCE_TAG \
           | jq -c '.')
echo "--> Upstream image manifests: $upstream"

latest=$((skopeo inspect --raw docker://$IMAGE:$SOURCE_TAG \
          || echo '"none"') \
         | jq -c '.')
echo "--> Latest image manifests: $latest"

if [ "$upstream" != "$latest" ]; then
  echo "--> CHANGED"
fi
