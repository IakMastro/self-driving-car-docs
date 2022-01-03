#!/bin/bash

printf "\\n\\n===> Build docs"
printf "\\n"

docker stop self-driving-car-documentation
docker container rm self-driving-car-documentation
docker pull hub.swarmlab.io:5480/antora

./0-cert.error

docker run -ti --name self-driving-car-documentation -p 8080:8080 -v $PWD:/antora -v $PWD/supplemental-ui:/antora/supplemental-ui hub.swarmlab.io:5480/antora  /bin/sh -c "DOCSEARCH_ENABLED=true DOCSEARCH_ENGINE=lunr DOCSEARCH_INDEX_VERSION=latest NODE_PATH=/usr/local/lib/node_modules:\$NODE_PATH exec sh -c '/antora/build-all.sh'"