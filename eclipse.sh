#!/bin/sh

# Workaround for OSTree resets all timestamps to 0 which confuses p2.
base="/app/eclipse/configuration/org.eclipse.equinox.simpleconfigurator/bundles.info"
config="$HOME/.var/app/org.eclipse.Java/eclipse/configuration/org.eclipse.equinox.simpleconfigurator"
timestamp="$config/.baseBundlesInfoTimestamp"
state="$config/.flatpakBaseBundlesInfo"

if [ -f "$timestamp" ]; then
    # Matches SimpleConfiguratorUtils.getFileLastModified(): ctime in milliseconds
    current_timestamp=$(LC_ALL=C stat -c %.3Z "$base" | tr -d .)
    current_hash=$(sha256sum < "$base" | cut -d ' ' -f 1)
    remembered_timestamp=$(sed -n 's/^bundlesInfoTimestamp=//p' "$timestamp")

    if [ "$remembered_timestamp" != "$current_timestamp" ] && [ -f "$state" ]; then
        read -r state_timestamp state_hash < "$state"
        if [ "$state_timestamp" = "$remembered_timestamp" ] && [ "$state_hash" = "$current_hash" ]; then
            sed -i "s/^bundlesInfoTimestamp=.*/bundlesInfoTimestamp=$current_timestamp/" "$timestamp"
            remembered_timestamp="$current_timestamp"
        fi
    fi

    if [ "$remembered_timestamp" = "$current_timestamp" ]; then
        echo "$current_timestamp $current_hash" > "$state"
    fi
fi

exec /app/eclipse/eclipse "$@"
