#!/bin/bash

REPO_ROOT="${PWD//getting-started*}getting-started/"
ONEZONE_CONFIG_DIR="${PWD}/config_onezone/"
ONEPROVIDER_CONFIG_DIR="${PWD}/config_oneprovider/"
ONEPROVIDER_DATA_DIR="${PWD}/oneprovider_data/"
ONEPROVIDER_APP_CONFIG="bin/config/app.config"
ONEPROVIDER_APP_CONFIG_PATH="${REPO_ROOT}${ONEPROVIDER_APP_CONFIG}"
SPACES_DIR="${PWD}/myspaces/"
AUTH_CONF="bin/config/auth.conf"
AUTH_PATH="${REPO_ROOT}${AUTH_CONF}"

HOSTNAME=$(hostname -s)

DEBUG=0;

docker_compose_sh="docker-compose"

# Error handling.
# $1 - error string
die() {
  echo "${0##*/}: error: $*" >&2
  exit 1
}

print_docker_compose_file() {
  local compose_file_name=$1
  echo "The docker compose file with substituted variables be used:
BEGINING===="

  # http://mywiki.wooledge.org/TemplateFiles
  LC_COLLATE=C
  while read -r; do
    while [[ $REPLY =~ \$(([a-zA-Z_][a-zA-Z_0-9]*)|\{([a-zA-Z_][a-zA-Z_0-9]*)\})(.*) ]]; do
      if [[ -z ${BASH_REMATCH[3]} ]]; then   # found $var
        printf %s "${REPLY%"${BASH_REMATCH[0]}"}${!BASH_REMATCH[2]}"
      else # found ${var}
        printf %s "${REPLY%"${BASH_REMATCH[0]}"}${!BASH_REMATCH[3]}"
      fi
      REPLY=${BASH_REMATCH[4]}
    done
    printf "%s\n" "$REPLY"
  done < "${compose_file_name}"
  echo "====END"
}

# As the name suggests
usage() {
  echo "Usage: ${0##*/}  [-h] [ --onezone  | --oneprovider ] [ --oneprovider-data-dir ] [ --onezone_ip ] [ -n  | --node ]

This script starts Onedata components:

Example usage:
${0##*/} --oneprovider -n2 --oneprovider-data-dir \"/mnt/super_fast_and_big_storage/\"
will start a second node of oneprovider service.

Options:
  -h, --help           display this help and exit
  --zone               starts onezone service
  --zone_ip            ip or hostname of onezone service
  --provider           starts oneprovider service
  --provider-dn        domain name for oneprovider      
  --provider-fqdn      FQDN for oneprovider      
  --zone-fqdn          FQDN for onezone
  --provider-data-dir  a directory where provider will store users raw data
  -n, --node           a node number to start, default value is 1
  --clean              clean all onezone, oneprivder and oneclient configuration and data files - provided all docker containers using them have been shutdown"
  exit 0
}

debug() {
  set -o posix ; set
}

clean() {
  rm -rf "$ONEZONE_CONFIG_DIR"
  rm -rf "$ONEPROVIDER_CONFIG_DIR"
  rm -rf "$ONEPROVIDER_DATA_DIR"
  rm -rf "$SPACES_DIR"
}

batch_mode_check() {
  local service=$1
  local compose_file_name=$2

  grep 'ONEPANEL_BATCH_MODE: "true"' "$compose_file_name" > /dev/null
  if [[ $? -eq 0 ]] ; then

    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    RESET="$(tput sgr0)"
  
    echo -e "${RED}IMPORTANT: After each start wait for a message: ${GREEN}Congratulations! ${service} has been successfully started.${RESET}"
    echo -e "${RED}To ensure that the ${service} is completely setup.${RESET}"
  fi
}

handle_onezone() {
  local n=$1
  local compose_file_name=$2
  mkdir -p "$ONEZONE_CONFIG_DIR"


  if [[ $DEBUG -eq 1 ]]; then
    docker_compose_sh_local() {
      echo AUTH_PATH="$AUTH_PATH" ONEZONE_CONFIG_DIR="$ONEZONE_CONFIG_DIR" ${docker_compose_sh} "$@"
    }
    print_docker_compose_file "$compose_file_name"
  else 
    docker_compose_sh_local() {
      ZONE_DOMAIN_NAME=$ZONE_DOMAIN_NAME PROVIDER_FQDN=$PROVIDER_FQDN ZONE_FQDN=$ZONE_FQDN HOSTNAME=$HOSTNAME AUTH_PATH=$AUTH_PATH ONEZONE_CONFIG_DIR="$ONEZONE_CONFIG_DIR" ${docker_compose_sh} "$@"
    }
  fi
  
  batch_mode_check "onezone" "$compose_file_name"
  docker_compose_sh_local -f "$compose_file_name" pull
  docker_compose_sh_local -f "$compose_file_name" up 
} 

handle_oneprovider() {
  local n=$1
  local compose_file_name=$2
  local onezone_ip=$3
  local oneprovider_data_dir=$4

  mkdir -p "$ONEPROVIDER_CONFIG_DIR"
  mkdir -p "$oneprovider_data_dir"


  if [[ $DEBUG -eq 1 ]]; then
    docker_compose_sh_local() {
      echo PROVIDER_DOMAIN_NAME=$PROVIDER_DOMAIN_NAME PROVIDER_FQDN=$PROVIDER_FQDN ZONE_FQDN=$ZONE_FQDN HOSTNAME=$HOSTNAME ONEZONE_IP="$onezone_ip" ONEPROVIDER_APP_CONFIG_PATH="$ONEPROVIDER_APP_CONFIG_PATH" ONEPROVIDER_CONFIG_DIR="$ONEPROVIDER_CONFIG_DIR " ONEPROVIDER_DATA_DIR="$oneprovider_data_dir" "${docker_compose_sh}" "$@"
    }
    docker_compose_sh_local="echo ${docker_compose_sh_local}"
    print_docker_compose_file "$compose_file_name"
  else
    docker_compose_sh_local() {
      PROVIDER_DOMAIN_NAME=$PROVIDER_DOMAIN_NAME PROVIDER_FQDN=$PROVIDER_FQDN ZONE_FQDN=$ZONE_FQDN HOSTNAME=$HOSTNAME ONEZONE_IP="$onezone_ip" ONEPROVIDER_APP_CONFIG_PATH="$ONEPROVIDER_APP_CONFIG_PATH" ONEPROVIDER_CONFIG_DIR="$ONEPROVIDER_CONFIG_DIR"  ONEPROVIDER_DATA_DIR="$oneprovider_data_dir" "${docker_compose_sh}" "$@"
    }
  fi

  batch_mode_check "oneprovider" "$compose_file_name"
  docker_compose_sh_local -f "$compose_file_name" pull
  docker_compose_sh_local -f "$compose_file_name" up
} 

main() {
  local oneprovider_data_dir=$ONEPROVIDER_DATA_DIR
  local n=1
  local service
  local onezone_ip=""
  local clean=0

  while (( $# )); do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit 0
              ;;
          --zone)      
              service="onezone"
              ;;
          --provider)       
              service="oneprovider"
              ;;
          --provider-data-dir)       
              oneprovider_data_dir=$2
              shift
              ;;
          -n|--node)    
              n=$2
              shift
              ;;
          --clean)    
              clean=1
              ;;
          --debug)
              DEBUG=1
              ;;      
          --zone_ip)
              ZONE_DOMAIN_NAME=$2
              shift
              ;;
          --zone-fqdn)
              ZONE_FQDN=$2
              shift
              ;;
          --provider-dn)
              PROVIDER_DOMAIN_NAME=$2
              shift
              ;;
          --provider-fqdn)
              PROVIDER_FQDN=$2
              shift
              ;;
          -?*)
              printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
              exit 1
              ;;
          *)
              die "no option $1"
              ;;
      esac
      shift
  done


  if [[ $clean -eq 1 ]]; then
    clean
    exit 0
  fi

  local compose_file_name="docker-compose-${service}.yml"

  if [[ $service == "onezone" ]]; then
    handle_onezone "$n" "$compose_file_name"
  fi

  if [[ $service == "oneprovider" ]]; then
    handle_oneprovider "$n" "$compose_file_name" "$onezone_ip" "$oneprovider_data_dir"
  fi

  if [[ $clean -eq 1 ]]; then
    debug
    exit 0
  fi
  
  
}

if (( $# )); then
  main "$@"
else
  usage
fi
