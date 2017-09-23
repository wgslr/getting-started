#!/bin/bash
YAML_FILE=docker-compose-datahub-zone-worker.yml
PROJECT_NAME=datahub-onezone-worker
FQDN=$(hostname -f)
DOMAIN_NAME=$(domainname -d)
HOSTNAME=$(hostname)

function start {
    local_copy_of_docker_compose_yaml=$(cat "$YAML_FILE" | sed  -e "s#\$FQDN#$FQDN#")
    docker rm -f onezone-1
    DOMAIN_NAME=$DOMAIN_NAME HOSTNAME=$HOSTNAME FQDN=$FQDN docker-compose --project-name $PROJECT_NAME  -f <(echo "$local_copy_of_docker_compose_yaml") config
    DOMAIN_NAME=$DOMAIN_NAME HOSTNAME=$HOSTNAME FQDN=$FQDN docker-compose --project-name $PROJECT_NAME  -f <(echo "$local_copy_of_docker_compose_yaml") up --force-recreate -d
    docker logs -f  onezone-1
}

function stop {
    FQDN=$FQDN docker-compose --project-name $PROJECT_NAME -f $YAML_FILE down
}

function restart {
    stop
    start
}

function error {
echo "Unknown command '$1'"
echo "Available commands: start|stop|restart"
exit 1
}

if [[ -z "${1}" ]]; then
    error
else
    case ${1} in
        start)
            start
            ;;
        stop)
            stop
            ;;
        restart)
            restart
            ;;
        *)
            error
            ;;
    esac
fi
