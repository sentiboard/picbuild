FROM debian:buster-slim
MAINTAINER sentiboard
ARG XC32_VER=v2.15
ARG MPLAB_VER=v5.35

# Install dependencies and 32-bit libraries for MPLAB installer
RUN dpkg --add-architecture i386 \
    && apt-get update && apt-get install -y --no-install-recommends \
    wget make procps libc6:i386 libstdc++6:i386 libexpat1:i386 libxext6:i386 git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Get required files:
RUN wget "http://ww1.microchip.com/downloads/en/DeviceDoc/xc32-${XC32_VER}-full-install-linux-installer.run" -O /tmp/mplabxc32linux
#COPY dl/xc32-${XC32_VER}-full-install-linux-installer.run /tmp/mplabxc32linux

RUN wget "http://ww1.microchip.com/downloads/en/DeviceDoc/MPLABX-${MPLAB_VER}-linux-installer.tar" -O /tmp/MPLABX-${MPLAB_VER}-linux-installer.tar
RUN tar -xf /tmp/MPLABX-${MPLAB_VER}-linux-installer.tar -C /tmp/
# COPY dl/MPLABX-${MPLAB_VER}-linux-installer.sh /tmp/MPLABX-${MPLAB_VER}-linux-installer.sh

# Install xc32:
RUN chmod +x /tmp/mplabxc32linux \
    && /tmp/mplabxc32linux --mode unattended --netservername docker \
    && rm /tmp/mplabxc32linux

# Install MPLAB IPE
RUN chmod +x /tmp/MPLABX-${MPLAB_VER}-linux-installer.sh \
    && USER=root /tmp/MPLABX-${MPLAB_VER}-linux-installer.sh --nox11 -- --8bitmcu 0 \
       --16bitmcu 0 --32bitmcu 1 --ipe 0 --unattendedmodeui minimal --mode unattended \
    && rm -rf /tmp/MPLABX-${MPLAB_VER}-linux-installer.sh /tmp/MPLABX-${MPLAB_VER}-linux-installer.tar
