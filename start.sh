#!/bin/bash

test_net() {
    podman network exists $1
    return $?
}

test_pod() {
    local RETVAL=$(podman compose --file $1 ps --format json | jq 'map(select(.State != "running")) | length')
    return $RETVAL
}

# Check for the reverse proxy network and create if it doesn't exist
if ! test_net caddy -eq 0; then
    echo "Creating network 'caddy'..."
    podman network create caddy
else
    echo "Network 'caddy' already exists"
fi

if ! test_pod caddy.yml -eq 0; then
    echo "Stopping pod 'caddy'"
    podman compose --file caddy.yml --env-file .env.caddy down
    echo "Starting pod 'caddy'"
    podman compose --file caddy.yml --env-file .env.caddy up --detach
else
    echo "Pod 'caddy' is already running"
fi

if ! test_pod portainer.yml -eq 0; then
    echo "Stopping pod 'portainer'"
    podman compose --file portainer.yml --env-file .env.portainer down
    echo "Starting pod 'portainer'"
    podman compose --file portainer.yml --env-file .env.portainer up --detach
else
    echo "Pod 'portainer' is already running"
fi

