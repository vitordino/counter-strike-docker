FROM debian:bullseye

LABEL maintainer = "Dmitry Zarva <zarv1k@gmail.com>"

ARG steam_user
ARG steam_password
ARG amxmod_version

RUN useradd -ms /bin/bash cstrike

RUN apt-get update && apt-get install -y lib32gcc1 curl unzip && rm -rf /var/lib/apt/lists/* && chown cstrike:cstrike /opt

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

# Install CSDM
RUN curl -sqL 'https://www.bailopan.net/csdm/files/csdm-2.1.2.zip' -o '/opt/csdm.zip' && \
    unzip -u '/opt/csdm.zip' -d /opt/hlds/cstrike/ && rm -f '/opt/csdm.zip'
    
# Patch CSDM https://forums.alliedmods.net/showpost.php?p=1909682&postcount=27?p=1909682&postcount=27
RUN curl -sqL 'https://forums.alliedmods.net/attachment.php?attachmentid=116910&d=1362864766' -o '/opt/patch.zip' && \
    unzip -jfo '/opt/patch.zip' -d /opt/hlds/cstrike/addons/amxmodx/modules && rm -f '/opt/patch.zip'

USER root
RUN apt-get remove -y curl unzip && apt-get autoremove -y
USER cstrike

WORKDIR /opt/hlds

ENTRYPOINT ["./hlds_run"]
