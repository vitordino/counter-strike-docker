#!/usr/bin/env bash

set -axe
HLDS="/opt/hlds"

CONFIG_FILE="${HLDS}/startup.cfg"

if [ -r "${CONFIG_FILE}" ]; then
    # TODO: make config save/restore mechanism more solid
    set +e
    # shellcheck source=/dev/null
    source "${CONFIG_FILE}"
    set -e
fi

EXTRA_OPTIONS=( "$@" )

EXECUTABLE="${HLDS}/hlds_run"
GAME="${GAME:-cstrike}"
MAXPLAYERS="${MAXPLAYERS:-32}"
START_MAP="${START_MAP:-de_dust2}"
SERVER_NAME="${SERVER_NAME:-Counter-Strike 1.6 Server}"

OPTIONS=( "-game" "${GAME}" "+maxplayers" "${MAXPLAYERS}" "+map" "${START_MAP}" "+hostname" "\"${SERVER_NAME}\"")


if [ -z "${RESTART_ON_FAIL}" ]; then
    OPTIONS+=('-norestart')
fi

# AMX Admin User
if [ -n "${ADMIN_STEAM}" ]; then
    echo "\"STEAM_${ADMIN_STEAM}\" \"\"  \"abcdefghijklmnopqrstu\" \"ce\"" >> "${HLDS}/cstrike/addons/amxmodx/configs/users.ini"
fi


# Set Server Password
if [ ! -z ${SERVER_PASSWORD} ]; then
    echo "sv_password \"${SERVER_PASSWORD}\"" >> "/opt/hlds/cstrike/server.cfg"
fi

# Enable AMX Plugins
echo "ultimate_sounds.amxx      ; Ultimate Sounds" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"
echo "deathbeams.amxx           ; Death Beams" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"
echo "resetscore.amxx           ; Reset Score" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"


# Enable YaPB Bots
if [ ! -z "${YAPB_ENABLED}" ];then
    YAPB_PASSWORD="${YAPB_PASSWORD:-yapb}"

    echo "linux addons/yapb/bin/yapb.so" >> "${HLDS}/cstrike/addons/metamod/plugins.ini"
    echo "yb_password \"${YAPB_PASSWORD}\"" >> "${HLDS}/cstrike/addons/yapb/conf/yapb.cfg"
    echo "amxx_yapbmenu.amxx      ; YAPB Menu" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"
fi


set > "${CONFIG_FILE}"

exec "${EXECUTABLE}" "${OPTIONS[@]}" "${EXTRA_OPTIONS[@]}"
