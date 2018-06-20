FROM golang:1.10.3

RUN wget -cO /flash-hypriot.sh ${FLASHER_URL} && chmod 777 /flash-hypriot.sh

RUN /flash-hypriot.sh --install-deps

CMD ["/flash-hypriot.sh"]
