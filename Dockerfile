FROM docker.io/library/ubuntu:24.04

ENV DEBCONF_NONINTERACTIVE_SEEN=true \
    DEBIAN_FRONTEND=noninteractive \
    APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn \
    DISPLAY=:0 \
    WINEDEBUG=-all \
    NVIDIA_DRIVER_CAPABILITIES=all \
    NVIDIA_VISIBLE_DEVICES=all

RUN \
    dpkg --add-architecture i386 \
    && \
    apt-get -qq update \
    && \
    apt-get -qq install -y --no-install-recommends --no-install-suggests \
        cabextract \
        catatonit \
        curl \
        mesa-utils \
        unzip \
        wget \
        xserver-xorg \
        xvfb\
    && \
    apt-get -qq install -y --install-recommends \
        wine \
        winetricks \
    && \
    mkdir -p /app/Fuser \
    && \
    rm -rf \
        /tmp/* \
        /var/lib/apt/lists/* \
        /var/tmp/

COPY Fuser.zip /tmp/pm.zip

RUN unzip /tmp/pm.zip -d /app/Fuser \
    && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN chmod 777 /entrypoint.sh

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu-user
RUN usermod -aG sudo ubuntu

USER ubuntu:ubuntu
WORKDIR /home/ubuntu

RUN \
    wineboot -u \
    && winetricks nocrashdialog \
    && winetricks -q dotnet48 
ENV WINEDLLOVERRIDES="concrt140,msvcp140,vcomp140,vcruntime140,vcruntime140_1=n" 

EXPOSE 22
EXPOSE 5900

ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
