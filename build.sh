#!/usr/bin/env bash


ARGS=$1 \
    docker compose --project-name ${PWD##*/}-builder \
        -f quarto-utils/docker-compose.yml \
        down -v \
        notebook-builder

ARGS=$1 \
    docker compose --project-name ${PWD##*/}-builder \
        -f quarto-utils/docker-compose.yml \
        up \
        notebook-builder
