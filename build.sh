#!/usr/bin/env bash

TOP_ARGS="$*"

function manage_docker() {
    local action=$1
    ARGS=$TOP_ARGS docker compose --project-name ${PWD##*/}-builder \
        -f quarto-utils/docker-compose.yml \
        $action 
}

manage_docker down -v
manage_docker "up notebook-builder"
manage_docker down -v
