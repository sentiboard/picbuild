FROM debian:buster
MAINTAINER sentiboard
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget make \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN wget http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-v2.40-full-install-linux-installer.run -O /tmp/mplabxc32linux
RUN chmod +x /tmp/mplabxc32linux
RUN /tmp/mplabxc32linux --mode unattended --netservername docker
RUN rm /tmp/mplabxc32linux
