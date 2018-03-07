FROM debian:jessie

LABEL maintainer = "Dmitry Zarva <zarv1k@gmail.com>"

ARG steam_user
ARG steam_password
ARG amxmod_version

RUN useradd -ms /bin/bash cstrike

RUN apt update && apt install -y lib32gcc1 curl \
    && chown cstrike:cstrike /opt

USER cstrike

# Install SteamCMD
RUN mkdir -p /opt/steam && cd /opt/steam && \
    curl -sqL "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz" | tar zxvf -

# Install HLDS
RUN mkdir -p /opt/hlds
# Workaround for "app_update 90" bug, see https://forums.alliedmods.net/showthread.php?p=2518786
RUN /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit
RUN /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 70 validate +quit || :
RUN /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 10 validate +quit || :
RUN /opt/steam/steamcmd.sh +login $steam_user $steam_password +force_install_dir /opt/hlds +app_update 90 validate +quit
RUN mkdir -p ~/.steam && ln -s /opt/hlds ~/.steam/sdk32
RUN ln -s /opt/steam/ /opt/hlds/steamcmd
COPY files/steam_appid.txt /opt/hlds/steam_appid.txt
COPY hlds_run.sh /bin/hlds_run.sh

# Add default config
COPY files/server.cfg /opt/hlds/cstrike/server.cfg

# Add maps
COPY maps/* /opt/hlds/cstrike/maps/
COPY files/mapcycle.txt /opt/hlds/cstrike/mapcycle.txt

# Install metamod
RUN mkdir -p /opt/hlds/cstrike/addons/metamod/dlls
COPY mod/metamod /opt/hlds/cstrike/addons/metamod/dlls
COPY files/liblist.gam /opt/hlds/cstrike/liblist.gam
# Remove this line if you aren't going to install/use amxmodx and dproto
COPY files/plugins.ini /opt/hlds/cstrike/addons/metamod/plugins.ini

# Install dproto
RUN mkdir -p /opt/hlds/cstrike/addons/dproto
COPY mod/dproto/dproto_i386.so /opt/hlds/cstrike/addons/dproto/dproto_i386.so
COPY mod/dproto/dproto.cfg /opt/hlds/cstrike/dproto.cfg

# Install AMX mod X
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-$amxmod_version-base-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
RUN curl -sqL "http://www.amxmodx.org/release/amxmodx-$amxmod_version-cstrike-linux.tar.gz" | tar -C /opt/hlds/cstrike/ -zxvf -
COPY files/maps.ini /opt/hlds/cstrike/addons/amxmodx/configs/maps.ini

# Install YaPB Bots
COPY mod/yapb /opt/hlds/cstrike/addons/yapb
COPY mod/yapbmenu/amxx_yapbmenu.sma /opt/hlds/cstrike/addons/amxmodx/scripting/amxx_yapbmenu.sma
COPY mod/yapbmenu/amxx_yapbmenu.amxx /opt/hlds/cstrike/addons/amxmodx/plugins/amxx_yapbmenu.amxx



USER root
RUN chown -R cstrike:cstrike /opt/*
# Cleanup
RUN apt remove -y curl

USER cstrike

WORKDIR /opt/hlds

ENTRYPOINT ["/bin/hlds_run.sh"]
