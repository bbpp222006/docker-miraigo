#!/bin/bash
docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
docker buildx create --use --name mybuilder
docker buildx build --tag scjtqs/miraigo:dev --platform linux/amd64,linux/arm64,linux/arm/v6 --push . \
&& docker buildx rm mybuilder
