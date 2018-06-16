FROM golang:1.10.3 AS frozen-images

RUN apt-get update && apt-get install -y jq ca-certificates --no-install-recommends

COPY download-frozen-image-v2.sh /

RUN mkdir /portainer /duckietown-software
RUN /download-frozen-image-v2.sh /portainer portainer/portainer:latest
RUN tar -czvf portainer.tar.gz /portainer/ 

FROM hypriot/image-builder:latest

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    binfmt-support \
    qemu \
    qemu-user-static \
    git \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/hypriot/image-builder-rpi /image-builder-rpi

COPY --from=frozen-images /go/portainer.tar.gz .
RUN mkdir /builder
RUN cp -R /image-builder-rpi/builder/ /builder

RUN ["bash", "/image-builder-rpi/builder/build.sh"]

CMD ["flash-hypriot.sh"]
