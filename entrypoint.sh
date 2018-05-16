#!/bin/bash

set -e
set -o pipefail

if [ ! -f "/app/minecraftsrv-${MINECRAFT_SERVER_VERSION}.jar" ]; then
    wget --no-check-certificate "https://cdn.getbukkit.org/craftbukkit/craftbukkit-${MINECRAFT_SERVER_VERSION}.jar" -O "/app/minecraftsrv-${MINECRAFT_SERVER_VERSION}.jar"
    ln -sf "/app/minecraftsrv-${MINECRAFT_SERVER_VERSION}.jar" "/app/minecraftsrv.jar"
fi

if [[ ${MINECRAFT_SERVER_AGREE_EULA} == "true" ]]; then
    echo "Automatically agreeing to EULA.."
    EULA_FILE="/app/eula.txt"
    if [ ! -f "${EULA_FILE}" ]; then
        echo "eula=true" > "${EULA_FILE}"
    else
        if grep -q "eula=false" "${EULA_FILE}"; then
            sed -i -e s/"eula=false"/"eula=true"/ "${EULA_FILE}"
        fi
    fi
fi

exec "$@"
