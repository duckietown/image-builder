FROM golang:1.10.3

RUN apt-get update && apt-get install -y jq ca-certificates wget tar lib32stdc++6 vim \
    # Required by hypriot/flash
    curl aws pv unzip hdparm sudo file udev --no-install-recommends

ENV ETCHER_URL="https://github.com/resin-io/etcher/releases/download/v1.4.4/etcher-cli-1.4.4-linux-x86.tar.gz"
ENV ETCHER_DIR="/tmp/etcher-cli"
ENV ETCHER_LOCAL="/tmp/etcher.download"

ENV HYPRIOT_URL="https://github.com/hypriot/image-builder-rpi/releases/download/v1.9.0/hypriotos-rpi-v1.9.0.img.zip"
ENV HYPRIOT_LOCAL="/tmp/hypriotos-rpi-v1.9.0.img.zip"

ENV IMAGE_DOWNLOADER_URL="https://raw.githubusercontent.com/moby/moby/master/contrib/download-frozen-image-v2.sh"
ENV FLASHER_URL="https://raw.githubusercontent.com/rusi/duckietown.dev.land/master/assets/flash-hypriot.sh"
ENV FLASH_URL="https://github.com/hypriot/flash/releases/download/2.1.1/flash"

RUN wget -cO ${ETCHER_LOCAL} ${ETCHER_URL}
RUN mkdir $ETCHER_DIR && tar fvx ${ETCHER_LOCAL} -C ${ETCHER_DIR} --strip-components=1

RUN wget -cO ${HYPRIOT_LOCAL} ${HYPRIOT_URL}

RUN wget -cO /download-frozen-image-v2.sh ${IMAGE_DOWNLOADER_URL} && chmod 777 /download-frozen-image-v2.sh
RUN wget -cO /flash-hypriot.sh ${FLASHER_URL} && chmod 777 /flash-hypriot.sh
RUN wget -cO /flash.sh ${FLASH_URL} && chmod 777 /flash.sh

RUN mkdir /portainer /duckietown-software
RUN /download-frozen-image-v2.sh /portainer portainer/portainer:latest
RUN /download-frozen-image-v2.sh /software duckietown/software:latest
RUN tar -czvf portainer.tar.gz /portainer/ 
RUN tar -czvf software.tar.gz /software/ 

RUN rm -rf /portainer/ /software/ ${ETCHER_LOCAL}

# FROM hypriot/image-builder:latest
# 
# RUN apt-get update && \
#     DEBIAN_FRONTEND=noninteractive apt-get install -y \
#     binfmt-support \
#     qemu \
#     qemu-user-static \
#     git \
#     --no-install-recommends && \
#     rm -rf /var/lib/apt/lists/*
# 
# RUN git clone https://github.com/hypriot/image-builder-rpi /image-builder-rpi
# 
# COPY --from=frozen-images /go/portainer.tar.gz .
# RUN mkdir /workspace
# RUN cp -R /image-builder-rpi/builder /workspace/
# 
# RUN ["bash", "/image-builder-rpi/builder/build.sh"]

CMD ["/flash.sh", "${HYPRIOT_LOCAL}"]
