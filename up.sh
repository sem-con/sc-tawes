#!/bin/bash
docker pull semcon/sc-tawes
docker rm -f tawes
IMAGE=semcon/sc-tawes:latest; docker run -d --name tawes -e IMAGE_SHA256="$(docker image ls --no-trunc -q $IMAGE | cut -c8-)" -e IMAGE_NAME=$IMAGE -p 9600:3000 -v /home/ownyourdata/docker/certs/:/certs/ $IMAGE script/init_zamg.sh "$(< config/init.trig)"