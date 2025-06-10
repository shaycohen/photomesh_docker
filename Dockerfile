FROM docker.io/library/ubuntu:24.04

ENV DEBCONF_NONINTERACTIVE_SEEN=true
ENV DEBIAN_FRONTEND=noninteractive
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
ENV DISPLAY=:0
ENV WINEDEBUG=-all
ENV NVIDIA_DRIVER_CAPABILITIES=all
ENV NVIDIA_VISIBLE_DEVICES=all

RUN dpkg --add-architecture i386
RUN apt-get update
RUN apt-get install -y --no-install-recommends --no-install-suggests cabextract catatonit curl mesa-utils unzip wget xserver-xorg xvfb
RUN apt-get install -y --install-recommends wine winetricks
RUN rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/

COPY Fuser.zip /tmp/pm.zip
RUN mkdir -p /app/Fuser
RUN unzip /tmp/pm.zip -d /app/Fuser && rm -rf /tmp/*

COPY entrypoint.sh /entrypoint.sh
RUN sudo chmod 755 /entrypoint.sh

RUN echo "ubuntu ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/ubuntu-user
RUN usermod -aG sudo ubuntu

USER ubuntu:ubuntu
WORKDIR /home/ubuntu

RUN wineboot -u 
RUN winetricks nocrashdialog
RUN winetricks --self-update
RUN winetricks -q dotnet48 
ENV WINEDLLOVERRIDES="concrt140,msvcp140,vcomp140,vcruntime140,vcruntime140_1=n" 

EXPOSE 5900
ENTRYPOINT ["/entrypoint.sh"]
CMD ["start"]
