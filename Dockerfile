FROM golang:1.10.3

ENV FLASHER_URL h.ndan.co

RUN wget -cO /flash-hypriot.sh ${FLASHER_URL} && chmod 777 /flash-hypriot.sh

RUN apt-get clean && apt-get update && apt-get upgrade -y

RUN /flash-hypriot.sh; exit 0

CMD ["/flash-hypriot.sh"]
