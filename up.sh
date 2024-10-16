#!/usr/bin/env bash


ARGS=$1 docker compose \
    --project-name ${PWD##*/} \
    -f quarto-utils/docker-compose.yml up $@ notebook -d

URL=""
until [ -n "$URL" ]; do
    sleep 1;    
    URL=$(ARGS="" docker compose \
        --project-name ${PWD##*/} \
        -f quarto-utils/docker-compose.yml logs | \
            grep "http://127.0.0.1:" | \
            tail -n 1 | \
            sed "s/8888/$(docker compose --project-name ${PWD##*/} -f quarto-utils/docker-compose.yml port notebook 8888|cut -d ':' -f 2)/" | \
            tr -s ' ' | \
            cut -d '|' -f 2);
done

echo "JupyterLab: $URL"

echo "VScode web : $(echo $URL|sed 's/lab\/tree\/local/codeserver/')&folder=/home/jovyan/work/local/"
