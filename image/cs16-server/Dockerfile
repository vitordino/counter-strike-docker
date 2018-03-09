FROM hlds-amxmodx:latest

LABEL maintainer = "Dmitry Zarva <zarv1k@gmail.com>"

USER cstrike

# Install Ultimate Sounds AMX plugin
COPY --chown=cstrike:cstrike mod/ultimate_sounds/misc/* /opt/hlds/cstrike/sound/misc/
COPY --chown=cstrike:cstrike mod/ultimate_sounds/ultimate_sounds.sma /opt/hlds/cstrike/addons/amxmodx/scripting/ultimate_sounds.sma
COPY --chown=cstrike:cstrike mod/ultimate_sounds/ultimate_sounds.amxx /opt/hlds/cstrike/addons/amxmodx/plugins/ultimate_sounds.amxx
COPY --chown=cstrike:cstrike mod/ultimate_sounds/ultimate_sounds.txt /opt/hlds/cstrike/addons/amxmodx/data/lang/ultimate_sounds.txt

# Install Deathbeams AMX plugin
COPY --chown=cstrike:cstrike mod/deathbeams/deathbeams.amxx /opt/hlds/cstrike/addons/amxmodx/plugins/deathbeams.amxx

# Install Reset Score AMX Plugin
COPY --chown=cstrike:cstrike mod/resetscore/resetscore.amxx /opt/hlds/cstrike/addons/amxmodx/plugins/resetscore.amxx

# Install HeadShot Only AMX Plugin
COPY --chown=cstrike:cstrike mod/hsonly/hsonly.sma /opt/hlds/cstrike/addons/amxmodx/scripting/hsonly.sma
COPY --chown=cstrike:cstrike mod/hsonly/hsonly.amxx /opt/hlds/cstrike/addons/amxmodx/plugins/hsonly.amxx
COPY --chown=cstrike:cstrike mod/hsonly/hs_only.txt /opt/hlds/cstrike/addons/amxmodx/data/lang/hs_only.txt

# Install YaPB Bots
COPY --chown=cstrike:cstrike mod/yapb /opt/hlds/cstrike/addons/yapb
COPY --chown=cstrike:cstrike mod/yapbmenu/amxx_yapbmenu.sma /opt/hlds/cstrike/addons/amxmodx/scripting/amxx_yapbmenu.sma
COPY --chown=cstrike:cstrike mod/yapbmenu/amxx_yapbmenu.amxx /opt/hlds/cstrike/addons/amxmodx/plugins/amxx_yapbmenu.amxx

# Apply metamod default plugins
COPY --chown=cstrike:cstrike image/cs16-server/plugins.ini /opt/hlds/cstrike/addons/metamod/plugins.ini

# Dproto config
COPY --chown=cstrike:cstrike mod/dproto/dproto.cfg /opt/hlds/cstrike/dproto.cfg

# Add maps
COPY --chown=cstrike:cstrike maps/* /opt/hlds/cstrike/maps/
COPY --chown=cstrike:cstrike config/mapcycle.txt /opt/hlds/cstrike/mapcycle.txt
COPY --chown=cstrike:cstrike config/maps.ini /opt/hlds/cstrike/addons/amxmodx/configs/maps.ini

# Add Entrypoint script
COPY --chown=cstrike:cstrike hlds_run.sh /bin/hlds_run.sh

# Add default server config
COPY --chown=cstrike:cstrike config/server.cfg /opt/hlds/cstrike/server.cfg

WORKDIR /opt/hlds

ENTRYPOINT ["/bin/hlds_run.sh"]
