FROM debian:jessie

LABEL maintainer = "Dmitry Zarva <zarv1k@gmail.com>"

ARG steam_user
ARG steam_password
ARG amxmod_version

RUN useradd -ms /bin/bash cstrike

RUN apt-get update && apt-get install -y lib32gcc1 curl  && rm -rf /var/lib/apt/lists/* && chown cstrike:cstrike /opt

USER cstrike

# Install SteamCMD
RUN mkdir -p /opt/steam /opt/hlds && cd /opt/steam && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Install HLDS
# Workaround for "app_update 90" bug, see https://forums.alliedmods.net/showthread.php?p=2518786
RUN /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit; \
    /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 70 validate +quit || \
    /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 10 validate +quit || \
    /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit
RUN mkdir -p ~/.steam && ln -s /opt/hlds ~/.steam/sdk32 && ln -s /opt/steam/ /opt/hlds/steamcmd
COPY --chown=cstrike:cstrike image/hlds-amxmodx/steam_appid.txt /opt/hlds/steam_appid.txt

# Install metamod
RUN mkdir -p /opt/hlds/cstrike/addons/metamod/dlls
COPY --chown=cstrike:cstrike mod/metamod /opt/hlds/cstrike/addons/metamod/dlls
COPY --chown=cstrike:cstrike image/hlds-amxmodx/liblist.gam /opt/hlds/cstrike/liblist.gam

# Install AMX mod X
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-$amxmod_version-base-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-$amxmod_version-cstrike-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -

# Install dproto
RUN mkdir -p /opt/hlds/cstrike/addons/dproto
COPY --chown=cstrike:cstrike mod/dproto/dproto_i386.so /opt/hlds/cstrike/addons/dproto/dproto_i386.so

USER root
RUN apt-get autoremove -y && apt remove -y curl
USER cstrike

WORKDIR /opt/hlds

ENTRYPOINT ["./hlds_run"]
