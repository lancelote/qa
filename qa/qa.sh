#!/usr/bin/env bash

version=0.1.1

if [[ $1 = "docker" ]]; then
    curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null
    if [[ "$?" != "0" ]]; then echo "Docker daemon is down" && exit 1; fi

    containers=$(docker ps -q)
    all_containers=$(docker ps -a -q)
    images=$(docker images -q)
    networks=$(docker network ls -q)
    volumes=$(docker volume ls -q)

    echo "Stop containers ..."
    if [[ ${containers} != "" ]]; then docker stop ${containers}; fi

    echo "Remove containers ..."
    if [[ ${all_containers} != "" ]]; then docker rm -f ${all_containers}; fi

    echo "Remove images ..."
    if [[ ${images} != "" ]]; then docker rmi -f ${images}; fi

    echo "Remove networks ..."
    if [[ ${networks} != "" ]]; then docker network rm ${networks}; fi

    echo "Remove volumes ..."
    if [[ ${volumes} != "" ]]; then docker volume rm ${volumes}; fi

    echo "Done"
elif [[ $1 = "archive" ]]; then
    archive=~/Desktop/$(basename "$PWD").zip
    zip -rq ${archive} .
    echo ${archive}
elif [[ $1 = "clean" ]]; then
    echo "Clean"
elif [[ $1 = "deploy" ]]; then
    for archive in ~/Downloads/pycharmP*.tar.gz; do
        echo "Deploying ${archive} ..."
        cat ${archive} | pv | ssh -p 2200 parallels@localhost \
            "tar xzf - -C ~/jetbrains"
    done
elif [[ $1 = "version" ]]; then
    echo "qa ${version}"
else
    echo "Unknown command"
fi
