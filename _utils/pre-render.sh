#!/bin/bash
BASE_PATH=$PWD
JAVA_VERSION=$(java --version|tail -1|cut -d ' ' -f 1,5)
MVN_VERSION=$(mvn --version|head -1|cut -d ' ' -f 1,2,3)
TOOLS_VERSION="$JAVA_VERSION - $MVN_VERSION"
DOCKER_SERVER_VERSION=$(docker version --format '{{.Server.Version}}')
DOCKER_CLIENT_VERSION="$(docker version --format '{{.Client.Version}}') $(docker info --format '{{json .}}'|jq -r '. | .ClientInfo.Plugins[] | " - \(.Name) \(.Version)"'| tr -d '\n')"

BRANCH=$(git branch --show-current)
HASH=$(git rev-parse --short HEAD)
#DATE=$(git log -1 --format="%at" | xargs -I{} date -d @{} +%Y-%m-%d\ %H:%M:%S)
DATE=$(git log -1 --date=format:"%Y/%m/%d %T" --format="%ad")
DOCUMENT_VERSION="$BRANCH ($HASH) $DATE"
GIT_REMOTE="$(git config --get remote.origin.url|cut -d '@' -f 2|sed 's/github.com:/https:\/\/github.com\//'|sed 's/\.git$//')"
(cat <<EOF
Version: $DOCUMENT_VERSION
Git repository: $GIT_REMOTE
Java tools: $TOOLS_VERSION
Docker: Client: $DOCKER_CLIENT_VERSION, Server: $DOCKER_SERVER_VERSION
EOF
) > ./quarto-utils/_version.md

# +----------------+--------------------------------------------------------------------------------------------------------+

(cat <<EOF
---
title: ""
author: ""
date: ""
---
EOF
) > ./quarto-utils/_version.qmd


(cat <<EOF
+                #+                                  #+
| Source         #| - [$GIT_REMOTE]($GIT_REMOTE)     #|
+                #+                                  #+
| Branch         #| - $BRANCH ($HASH)                #|
|                #| - $DATE                          #|
+                #+                                  #+
| Java           #| - $JAVA_VERSION                  #|
|                #| - $MVN_VERSION                   #|
+                #+                                  #+
| Docker         #| - Client: $DOCKER_CLIENT_VERSION #|
|                #| - Server: $DOCKER_SERVER_VERSION #|
+                #+                                  #+
EOF
) |column -t -s '#'|sed -e '/^+/s/ /-/g' >> ./quarto-utils/_version.qmd
#) |column -t -s '#'|sed -e '/^+/s/ /-/g'|sed 's/+/|/g' >> ./quarto-utils/_version.qmd

(cat <<EOF
: {.striped .hover .bordered}
EOF
) >> ./quarto-utils/_version.qmd

# cat ./quarto-utils/_version.qmd

(cat <<EOF
DOCUMENT_VERSION="$DOCUMENT_VERSION"
GIT_REMOTE="$GIT_REMOTE"
TOOLS_VERSION="$TOOLS_VERSION"
DOCKER_CLIENT_VERSION="$DOCKER_CLIENT_VERSION"
DOCKER_SERVER_VERSION="$DOCKER_SERVER_VERSION"
EOF
) > ./quarto-utils/_environment
