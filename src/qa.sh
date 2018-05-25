#!/usr/bin/env bash

version=0.1.4

if [[ $1 = "docker" ]]; then
    curl -s --unix-socket /var/run/docker.sock http://ping > /dev/null
    if [[ "$?" != "0" ]]; then echo "Docker daemon is down" && exit 1; fi
    if [[ ! -x "$(command -v docker)" ]]; then echo "No docker in PATH" && exit 1; fi
    
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
    if [[ ! $2 =~ ^PyCharm(CE)?[0-9]{4}\.[0-9]$ ]]; then echo "Wrong version" && exit 1; fi

    configs="${HOME}/Library/Preferences/$2"
    caches="${HOME}/Library/Caches/$2"
    plugins="${HOME}/Library/Application Support/$2"
    logs="${HOME}/Library/Logs/$2"

    echo "rm ${configs}" && rm -rf "${configs}"
    echo "rm ${caches}"  && rm -rf "${caches}"
    echo "rm ${plugins}" && rm -rf "${plugins}"
    echo "rm ${logs}"    && rm -rf "${logs}"
elif [[ $1 = "deploy" ]]; then
    for archive in ~/Desktop/pycharmP*.tar.gz; do
        echo "Deploying ${archive} ..."
        cat "${archive}" | pv | ssh -p 2200 parallels@localhost "tar xzf - -C ~/jetbrains"
        echo "rm ${archive}"
        rm "${archive}"
    done
elif [[ $1 = "version" ]]; then
    echo "qa $version"
else
    echo "Unknown command"
fi
