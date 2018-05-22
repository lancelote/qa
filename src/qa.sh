#!/usr/bin/env bash

version=0.1.2

if [[ $1 = "docker" ]]; then
    curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null
    if [[ "$?" != "0" ]]; then echo "Docker daemon is down" && exit 1; fi

    running_containers=$(docker ps -q)
    all_containers=$(docker ps -a -q)
    images=$(docker images -q)
    networks=$(docker network ls -q)
    volumes=$(docker volume ls -q)

    echo -n "Stop containers "
    for running_container in ${running_containers}; do
        docker stop ${running_container} > /dev/null
        echo -n "."
    done
    echo ""

    echo -n "Remove containers "
    for container in ${all_containers}; do
        docker rm -f ${container} > /dev/null
        echo -n "."
    done
    echo ""

    echo -n "Remove images "
    for image in ${images}; do
        docker rmi -f ${image} > /dev/null
        echo -n "."
    done
    echo ""

    echo -n "Remove networks "
    for network in ${networks}; do
        docker network rm ${network} > /dev/null
        echo -n "."
    done
    echo ""

    echo -n "Remove volumes "
    for volume in ${volumes}; do
        docker volume rm ${volume} > /dev/null
        echo -n "."
    done
    echo ""

    echo "Done"
elif [[ $1 = "archive" ]]; then
    archive=~/Desktop/$(basename "${PWD}").zip
    zip -rq ${archive} .
    echo ${archive}
elif [[ $1 = "clean" ]]; then
    echo "Clean"
elif [[ $1 = "deploy" ]]; then
    for archive in ~/Desktop/pycharmP*.tar.gz; do
        echo "Deploying ${archive} ..."
        cat ${archive} | pv | ssh -p 2200 parallels@localhost "tar xzf - -C ~/jetbrains"
    done
elif [[ $1 = "version" ]]; then
    echo "qa $version"
else
    echo "Unknown command"
fi
