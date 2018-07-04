#!/usr/bin/env bash

# Make sure to set the following environment variables:
#
#   PROJECTS_BACKUP - path to pycharm-qa-projects local repository copy
#   VM_USER         - Ubuntu VM user name
#   VM_PORT         - Ubuntu VM SSH port
#   VM_KEY          - path to Ubuntu VM SSH secret key
#   VM_PATH         - path on Ubuntu VM to install PyCharm to

version=0.1.11
ide_version_pattern="^((PyCharm(CE)?)|(IdeaIC)|(IntelliJIdea))[0-9]{4}\.[0-9]$"
project="$(basename "${PWD}")"

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
        docker stop ${running_container} > /dev/null 2>&1
        echo -n "."
    done
    echo ""

    echo -n "Remove containers "
    for container in ${all_containers}; do
        docker rm -f ${container} > /dev/null 2>&1
        echo -n "."
    done
    echo ""

    echo -n "Remove images "
    for image in ${images}; do
        docker rmi -f ${image} > /dev/null 2>&1
        echo -n "."
    done
    echo ""

    echo -n "Remove networks "
    for network in ${networks}; do
        docker network rm ${network} > /dev/null 2>&1
        echo -n "."
    done
    echo ""

    echo -n "Remove volumes "
    for volume in ${volumes}; do
        docker volume rm ${volume} > /dev/null 2>&1
        echo -n "."
    done
    echo ""

    echo "Done"
elif [[ $1 = "archive" ]]; then
    archive=~/Desktop/$(basename "${PWD}").zip
    zip -rq ${archive} .
    echo ${archive}
elif [[ $1 = "clean" ]]; then
    if [[ ! $2 =~ ${ide_version_pattern} ]]; then echo "Wrong version" && exit 1; fi

    configs="${HOME}/Library/Preferences/$2"
    caches="${HOME}/Library/Caches/$2"
    plugins="${HOME}/Library/Application Support/$2"
    logs="${HOME}/Library/Logs/$2"

    echo "rm ${configs}" && rm -rf "${configs}"
    echo "rm ${caches}"  && rm -rf "${caches}"
    echo "rm ${plugins}" && rm -rf "${plugins}"
    echo "rm ${logs}"    && rm -rf "${logs}"
elif [[ $1 = "deploy" ]]; then
    if [[ -z "${VM_USER}" || -z "${VM_PORT}" || -z "${VM_KEY}" || -z "${VM_PATH}" ]]; then
	echo "Please set all VM variables" && exit 1
    fi
    shopt -s nullglob
    for archive in ~/Desktop/{idea,pycharm}*.tar.gz; do
        echo "deploying ${archive} ..."
        cat "${archive}" | ssh "${VM_USER}@localhost" -p "${VM_PORT}" -i "${VM_KEY}" "tar xzf - -C ${VM_PATH}"
        echo "rm ${archive}"
        rm "${archive}"
    done
    for plugin in ~/Desktop/python*.zip; do
	scp -P 2200 -i ~/.ssh/parallels_vm "${plugin}" parallels@localhost:/home/parallels/jetbrains
    done
    shopt -u nullglob
elif [[ $1 = "save" ]]; then
    if [[ -z "${PROJECTS_BACKUP}" ]]; then echo "Please set PROJECTS_BACKUP folder" && exit 1; fi
    rm -rf "${PROJECTS_BACKUP}/${project}"
    cp -r "../${project}" "${PROJECTS_BACKUP}"
elif [[ $1 = "goto" ]]; then
    if [[ -z "${PROJECTS_BACKUP}" ]]; then echo "Please set PROJECTS_BACKUP folder" && exit 1; fi
    if [[ $2 = "backups" ]]; then
	cd "${PROJECTS_BACKUP}"
    elif [[ $2 = "backup" ]]; then
	if [[ -z $3 ]]; then
	    cd "${PROJECTS_BACKUP}/${project}"
	else
	    cd "${PROJECTS_BACKUP}/$3"
	fi
    fi
elif [[ $1 = "version" ]]; then
    echo "qa $version"
else
    echo "Unknown command"
fi
