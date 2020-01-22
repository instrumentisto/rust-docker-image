#!/bin/bash


if [ -z "$IMAGE_OS" ]; then
  echo "error: No IMAGE_OS env var provided"
  exit 1
fi
if [ -z "$TRIGGER_TOKEN" ]; then
  echo "error: No TRIGGER_TOKEN env var provided"
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

docker pull instrumentisto/rust:beta-$IMAGE_OS
latestImageVer=$(docker run --rm instrumentisto/rust:beta-$IMAGE_OS \
                 rustc -V \
                 | tr -d "\n")
echo "--> Latest image version: $latestImageVer"

if [ "rustc $currentToolchainVer" != "$latestImageVer" ]; then
  curl -sS -H "Content-Type: application/json" \
       --data "{\"build\":true,\"docker_tag\":\"beta-$IMAGE_OS\"}" \
       -X POST https://hub.docker.com/api/build/v1/source/$TRIGGER_TOKEN/call/ \
    >/dev/null \
  && echo "--> Build trigerred"
else
  echo "--> Image is up-to-date, no need to trigger build"
fi
