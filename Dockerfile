FROM ubuntu:16.04

COPY dam-init.sh /dam-init.sh

RUN chmod +x /dam-init.sh