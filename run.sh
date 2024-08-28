#!/usr/bin/env bash

ARGS="" docker compose \
    --project-name ${PWD##*/} \
    -f quarto-utils/docker-compose.yml logs | \
        grep "http://127.0.0.1:8888" | \
        tail -n 1 | \
        sed "s/8888/$(docker compose --project-name ${PWD##*/} -f quarto-utils/docker-compose.yml port notebook 8888|cut -d ':' -f 2)/"\
        |tr -s ' ' | \
        cut -d '|' -f 2

