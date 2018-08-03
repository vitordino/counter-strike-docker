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
CSDM_MODE="${CSDM_MODE:-0}"

OPTIONS=( "-game" "${GAME}" "+maxplayers" "${MAXPLAYERS}" "+map" "${START_MAP}" "+hostname" "\"${SERVER_NAME}\"")


if [ -z "${RESTART_ON_FAIL}" ]; then
    OPTIONS+=('-norestart')
fi

# AMX Admin Users by IP
if [ -n "${ADMIN_IP}" ]; then
    for ip in ${ADMIN_IP//,/ }
    do
        echo "\"${ip}\" \"\"  \"abcdefghijklmnopqrstu\" \"de\"" >> "${HLDS}/cstrike/addons/amxmodx/configs/users.ini"
    done
fi

# AMX Admin Users by Name
if [ -n "${ADMIN_NAME}" ] && [ -n "${ADMIN_PASSWORD}" ]; then
    for name in ${ADMIN_NAME//,/ }
    do
        echo "\"${name}\" \"${ADMIN_PASSWORD}\"  \"abcdefghijklmnopqrstu\" \"a\"" >> "${HLDS}/cstrike/addons/amxmodx/configs/users.ini"
    done
fi

# Set Server Password
if [ -n ${SERVER_PASSWORD} ]; then
    echo "sv_password \"${SERVER_PASSWORD}\"" >> "${HLDS}/cstrike/server.cfg"
fi

# Enable AMX Plugins
# echo "restmenu.amxx             ; Restrict Weapons" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"
# echo "deathbeams.amxx           ; Death Beams" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"
# echo "hsonly.amxx               ; HeadShot Only" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"

# Disable AMX Messages
sed -ri 's/(adminhelp|multilingual|adminchat|antiflood|scrollmsg|imessage|adminvote)\.amxx.*//g' "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"

# Enable YaPB Bots
if [ "${YAPB_ENABLED}" -eq 1 ];then
    YAPB_PASSWORD="${YAPB_PASSWORD:-yapb}"

    echo "linux addons/yapb/bin/yapb.so" >> "${HLDS}/cstrike/addons/metamod/plugins.ini"
    echo "yb_password \"${YAPB_PASSWORD}\"" >> "${HLDS}/cstrike/addons/yapb/conf/yapb.cfg"
    echo "amxx_yapbmenu.amxx      ; YAPB Menu" >> "${HLDS}/cstrike/addons/amxmodx/configs/plugins.ini"
fi

# Enable CSDM
if [ "${CSDM_MODE}" -ge 1 ]; then
     echo 'csdm_active "1"' >> "${HLDS}/cstrike/server.cfg"
else
    echo 'csdm_active "0"' >> "${HLDS}/cstrike/server.cfg"
fi

if [ "${CSDM_MODE}" -ge 2 ]; then
     echo 'csdm_ffa_enable "1"' >> "${HLDS}/cstrike/server.cfg"
fi

set > "${CONFIG_FILE}"

exec "${EXECUTABLE}" "${OPTIONS[@]}" "${EXTRA_OPTIONS[@]}"
