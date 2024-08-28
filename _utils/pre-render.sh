#!/bin/bash
BASE_PATH=$PWD
TOOLS_VERSION="$(java --version|tail -1|cut -d ' ' -f 1,5) - $(mvn --version|head -1|cut -d ' ' -f 1,2,3)"
DOCKER_SERVER_VERSION=$(docker version --format '{{.Server.Version}}')
DOCKER_CLIENT_VERSION="$(docker version --format '{{.Client.Version}}') $(docker info --format '{{json .}}'|jq -r '. | .ClientInfo.Plugins[] | " - \(.Name) \(.Version)"'| tr -d '\n')"

echo "--> $BASE_PATH $TOOLS_VERSION <--"

#for dir in $(ls -d [notebook-]*/); do
#	cd $dir
	BRANCH=$(git branch --show-current)
	HASH=$(git rev-parse --short HEAD)
	DOCUMENT_VERSION="$BRANCH ($HASH) "$(git log -1 --format="%at" | xargs -I{} date -d @{} +%Y-%m-%d\ %H:%M:%S)
	GIT_REMOTE="$(git config --get remote.origin.url|cut -d '@' -f 2|sed 's/github.com:/https:\/\/github.com\//'|sed 's/\.git$//')"
	(cat <<EOF
Version: $DOCUMENT_VERSION
Git repository: $GIT_REMOTE
Java tools: $TOOLS_VERSION
Docker: Client: $DOCKER_CLIENT_VERSION, Server: $DOCKER_SERVER_VERSION
EOF
) > _version.md

(cat <<EOF
|                |                       |
| :-------------- | :--------------------- |
| Version        | ${DOCUMENT_VERSION}   |
| Git repository | [${GIT_REMOTE}](${GIT_REMOTE})         |
| Java tools     | ${TOOLS_VERSION}      |
| Docker         | Client: ${DOCKER_CLIENT_VERSION} <br/> Server: ${DOCKER_SERVER_VERSION}  |
EOF
) > _version.qmd

(cat <<EOF
DOCUMENT_VERSION="$DOCUMENT_VERSION"
GIT_REMOTE="$GIT_REMOTE"
TOOLS_VERSION="$TOOLS_VERSION"
DOCKER_CLIENT_VERSION="$DOCKER_CLIENT_VERSION"
DOCKER_SERVER_VERSION="$DOCKER_SERVER_VERSION"
EOF
) > _environment

# echo "--> $dir <--"
# cat _version.qmd
#cd $BASE_PATH
#done

#for l in $(find "$(pwd -P)" -name *_L_*.ipynb -and -not -name "*-checkpoint.ipynb");
#do
#	my_link=$(echo $l|sed s'/_L_/_L-slides_/'	
#	[ -L ${my_link} ] || ln -s $l ${my_link})
#done


