FROM ubuntu:16.04

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --yes pulseaudio-utils x11-apps sudo

COPY dam-init.sh /dam-init.sh

RUN chmod +x /dam-init.sh