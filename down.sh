#!/usr/bin/env bash


ARGS="" docker compose \
    --project-name ${PWD##*/} \
    -f quarto-utils/docker-compose.yml down $@


