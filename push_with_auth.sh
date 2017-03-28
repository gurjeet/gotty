#!/usr/bin/env bash

# Abort this script on any failure
set -e

if [[ $(pwd) != */gotty-cf-bash ]]; then
    echo "This script should be executed from top directory in gotty-cf-bash code" >&2
    exit 1
fi

export UP=$(pwgen 20 2 | paste -s -d ':' -)

# Munge the manifest command.  Putting this in a the env section as
# GOTTY_CREDENTIAL exposed the secret via cf env, which attackers can launch
# trivially.
yq --arg up $UP '.applications[0].command="gotty -c \($up) -w bash"| .applications[0].memory="1g"' < manifest.yml.in > manifest.yml

cf push gotty-${USER} --random-route
echo "You can get in with this command, or navigate to the URL if you prefer."
echo "This message will not be repeated."
JQ='.routes[] | "gotty-client https://\(env.UP)@\(.host).\(.domain.name)"'
cf curl /v2/apps/$(cf app --guid gotty-${USER})/summary | jq -r "$JQ"
