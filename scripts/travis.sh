#!/bin/bash

set -e

image=lins05/seadrive-builder:latest
container=seafile-client-deb-builder

mapfile -t travis_env < <(env |grep TRAVIS)
docker_envs=""
for k in ${travis_env[*]}; do
    docker_envs="$docker_envs -e $k"
done

docker rm -f $container || true

docker run -it $docker_envs \
       -e "BINTRAY_AUTH=$BINTRAY_AUTH" \
       -e "SLACK_NOTIFY_URL=$SLACK_NOTIFY_URL" \
       -v "$(pwd):/app" \
       --privileged \
       --name $container \
       $image \
       /app/build-debs.sh

       # bash -c '/app/build.sh || sleep 30000'
