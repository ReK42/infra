#!/bin/bash

usage() {
    echo "$0 <start|stop|restart|status>"
}

create_net() {
    # create_net <name>
    #local retval=$(test_net $1)
    if [[ $retval -ne 0 ]]; then
        echo "Creating network '$1'..."
        #retval=$(podman network create $1)
    fi
    local retval=0
    return $retval
}

test_net() {
    # test_net <name>
    #local retval=$(podman network exists $1)
    local retval=0
    return $retval
}

test_pod() {
    # test_pod <name>
    #local retval=$(podman compose --file $1 ps --format json | jq 'map(select(.State != "running")) | length')
    local retval=0
    return $retval
}

start_pod() {
    # start_pod <name>
    echo "Starting pod '$1'..."
    local COMPOSE="$1/compose.yml"
    local ENVFILE="$1/stack.env"
    #local retval=$(podman compose --file $COMPOSE --env-file $ENVFILE up --detach)
    local retval=0
    if [[ $retval -ne 0 ]]; then
        echo "Error: Unable to start pod $1" >&2
    fi
    return $retval
}

stop_pod() {
    # stop_pod <name>
    echo "Stopping pod '$1'..."
    local COMPOSE="$1/compose.yml"
    local ENVFILE="$1/stack.env"
    #local retval=$(podman compose --file $COMPOSE --env-file $ENVFILE down)
    local retval=0
    if [[ $retval -ne 0 ]]; then
        echo "Error: Unable to stop pod $1" >&2
    fi
    return $retval
}

restart_pod() {
    # restart_pod <name>
    stop_pod $1
    if [[ $? -eq 0 ]]; then
        start_pod $1
    fi
}

status_net() {
    # status_net <name>
    local retval=$(test_net $1)
    if [[ $retval -eq 0 ]]; then
        echo "Network '$1' exists"
    else
        echo "Network '$1' does not exist"
    fi
    return $retval
}

status_pod() {
    # status_pod <name>
    local retval=$(test_pod $1)
    if [[ $retval -eq 0 ]]; then
        echo "Pod '$1' is running"
    else
        echo "Pod '$1' is not running"
    fi
    return $retval
}



if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root: Portainer requires privileged=true"
    exit 1
fi

case "$1" in
    start)
        create_net proxy
        start_pod portainer
        exit $?
        ;;
    stop)
        stop_pod portainer
        exit $?
        ;;
    restart)
        create_net proxy
        restart_pod portainer
        exit $?
        ;;
    status)
        status_net proxy
        status_pod portainer
        exit $?
        ;;
    *)
        usage
        exit 0
esac
