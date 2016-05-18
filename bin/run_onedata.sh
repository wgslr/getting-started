#!/bin/bash
# POSIX

PWD=$(pwd)
REPO_ROOT="${PWD//getting-started*}getting-started/"
ONEZONE_CONFIG_DIR="${PWD}/config_onezone/"
ONEPROVIDER_CONFIG_DIR="${PWD}/config_oneprovider/"
ONEPROVIDER_DATA_DIR="${PWD}/oneprovider_data/"
ONEPROVIDER_APP_CONFIG="bin/config/app.config"
ONEPROVIDER_APP_CONFIG_PATH="${REPO_ROOT}${ONEPROVIDER_APP_CONFIG}"
SPACES_DIR="${PWD}/myspaces/"
AUTH_CONF="bin/config/auth.conf"
AUHT_PATH="${REPO_ROOT}${AUTH_CONF}"
DEBUG=0;

# Error handling.
# $1 - error string
die() {
  echo "${0##*/}: error: $*" >&2
  exit 1
}

# As the name suggests
usage() {
  echo "Usage: ${0##*/}  [-h] [ --onezone  | --oneprovider ] [ --oneprovider-data-dir ] [ --onezone_ip ] [ -n  | --node ]

This script starts Onedata components:

Example usage:
${0##*/} --oneprovider -n2 --oneprovider-data-dir \"/mnt/super_fast_and_big_storage/\"
will start a second node of oneprovider service.

Options:
  -h, --help              display this help and exit
  --onezone               starts onezone service
  --onezone_ip            ip or hostname of onezone service
  --oneprovider           starts oneprovider service
  --oneprovider-data-dir  a directory where provider will store users raw data
  -n, --node              a node number to start, default value is 1
  --clean                 clean all onezone, oneprivder and oneclient configuration and data files - provided all docker containers using them have been shutdown"
  exit 0
}

function debug {
  set -o posix ; set
}

function clean {
  rm -rf $ONEZONE_CONFIG_DIR
  rm -rf $ONEPROVIDER_CONFIG_DIR
  rm -rf $ONEPROVIDER_DATA_DIR
  rm -rf $SPACES_DIR
}

function batch_mode_check {
  local service=$1
  local compose_file_name=$2

  grep 'ONEPANEL_BATCH_MODE: "true"' $compose_file_name > /dev/null
  if [[ $? -eq 0 ]] ; then

    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    RESET="$(tput sgr0)"
  
    echo -e "${RED}IMPORTANT: After each start wait for a message: ${GREEN}Congratulations! ${service} has been successfully started.${RESET}"
    echo -e "${RED}To ensure that the ${service} is completely setup.${RESET}"
  fi
}

function handle_onezone {
  local n=$1
  local compose_file_name=$2
  
  mkdir -p $ONEZONE_CONFIG_DIR

  batch_mode_check "onezone" $compose_file_name

  AUTH_PATH=$AUHT_PATH ONEZONE_CONFIG_DIR=$ONEZONE_CONFIG_DIR docker-compose -f $compose_file_name pull
  if [[ $DEBUG -eq 1 ]]; then
    echo AUTH_PATH=$AUHT_PATH ONEZONE_CONFIG_DIR=$ONEZONE_CONFIG_DIR docker-compose -f $compose_file_name up "node${n}.${service}.onedata.example.com"
  else 
    AUTH_PATH=$AUHT_PATH ONEZONE_CONFIG_DIR=$ONEZONE_CONFIG_DIR docker-compose -f $compose_file_name up "node${n}.${service}.onedata.example.com"
  fi
} 

function handle_oneprovider {
  local n=$1
  local compose_file_name=$2
  local onezone_ip=$3
  local oneprovider_data_dir=$4
 
  mkdir -p $ONEPROVIDER_CONFIG_DIR
  mkdir -p $oneprovider_data_dir

  batch_mode_check "oneprovider" $compose_file_name

  ONEZONE_IP="$onezone_ip" ONEPROVIDER_APP_CONFIG_PATH=$ONEPROVIDER_APP_CONFIG_PATH ONEPROVIDER_CONFIG_DIR=$ONEPROVIDER_CONFIG_DIR  ONEPROVIDER_DATA_DIR=$oneprovider_data_dir docker-compose -f $compose_file_name pull
  if [[ $DEBUG -eq 1 ]]; then
    echo ONEZONE_IP="$onezone_ip" ONEPROVIDER_APP_CONFIG_PATH=$ONEPROVIDER_APP_CONFIG_PATH ONEPROVIDER_CONFIG_DIR=$ONEPROVIDER_CONFIG_DIR  ONEPROVIDER_DATA_DIR=$oneprovider_data_dir docker-compose -f $compose_file_name up "node${n}.${service}.onedata.example.com"
  else
    ONEZONE_IP="$onezone_ip" ONEPROVIDER_APP_CONFIG_PATH=$ONEPROVIDER_APP_CONFIG_PATH ONEPROVIDER_CONFIG_DIR=$ONEPROVIDER_CONFIG_DIR  ONEPROVIDER_DATA_DIR=$oneprovider_data_dir docker-compose -f $compose_file_name up "node${n}.${service}.onedata.example.com"
  fi
} 

main() {
  local oneprovider_data_dir=$ONEPROVIDER_DATA_DIR
  local n=1
  local service
  local onezone_ip
  local clean=0

  while [[ $# > 0 ]]; do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit 0
              ;;
          --onezone)      
              service="onezone"
              ;;
          --oneprovider)       
              service="oneprovider"
              ;;
          --oneprovider-data-dir)       
              service=$2
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
          --onezone_ip)
              onezone_ip=$2
              shift
              ;;
          -?*)
              printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
              exit 1
              ;;
          *)
              die "no option ${flag}"
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
    handle_onezone $n $compose_file_name
  fi

  if [[ $service == "oneprovider" ]]; then
    handle_oneprovider $n $compose_file_name $onezone_ip $oneprovider_data_dir 
  fi

  if [[ $clean -eq 1 ]]; then
    debug
    exit 0
  fi
  
  
}

if [ $# -lt 1 ]; then
    usage
fi

main "$@"
