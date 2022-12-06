#!/bin/bash


if [ -z "$IMAGE" ]; then
  echo "error: No IMAGE env var provided"
  exit 1
fi
if [ -z "$IMAGE_OS" ]; then
  echo "error: No IMAGE_OS env var provided"
  exit 1
fi


set -e


curl -fL -o ./channel-rust-beta.toml \
     https://static.rust-lang.org/dist/channel-rust-beta.toml
currentToolchainVer=$(grep -A1 '\[pkg.rustc]' channel-rust-beta.toml \
                      | grep version \
                      | cut -d '"' -f2 \
                      | tr -d "\n")
echo "--> Current toolchain version: rustc $currentToolchainVer"

docker pull $IMAGE:beta-$IMAGE_OS || echo 'none'
latestImageVer=$((docker run --rm $IMAGE:beta-$IMAGE_OS rustc -V \
                  || echo '"none"') \
                 | tr -d "\n")
echo "--> Latest image version: $latestImageVer"

if [ "rustc $currentToolchainVer" != "$latestImageVer" ]; then
  echo "--> CHANGED"
fi
