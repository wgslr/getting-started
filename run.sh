#!/bin/bash
# POSIX

# To exit this scenario and stop all onedata components use CTRL-C in the terminal.

# Reset all variables that might be set
. ./env.sh

# Error handling.
# $1 - error string
die() {
  echo "${0##*/}: error: $*" >&2
  exit 1
}

# As the name suggests
usage() {
  echo "Usage: ${0##*/}  [-h] [ -se <service>] -s <number>

This script starts specified Onedata scenarios from directories ./scenario{N}

Example usage:
${0##*/} -s 1 -se oneprovider

Options:
  -h, --help       display this help and exit
  -s, --scenario   run specified scenario
  -se, --service   run specyfic service from the scenario"
  exit 0
}


main() {
  local n=0
  local service

  while [[ $# > 0 ]]; do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit
              ;;
          --scenario)       # specify scenari number
              if [ -n "$2" ]; then
                  n=$2
                  shift
              else
                  printf 'ERROR: "--scenario" requires a non-empty option argument.\n' >&2
                  exit 1
              fi
              ;;
          --service)       # specify service name
              if [ -n "$2" ]; then
                  service=$2
                  shift
              else
                  printf 'ERROR: "--service" requires a non-empty option argument.\n' >&2
                  exit 1
              fi
              ;;
          -?*)
              printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
              ;;
          *)               # Default case: If no more options then break out of the loop.
              forward_args="$forward_args $1"
      esac
      shift
  done

  if [[ -z ${n+x} ]]; then
    die "-s flag missing, please specify the scenario number "
  fi

  if [[ -z ${service+x} ]]; then
    cd "scenario$n" && docker-compose up "$service"
  else
    cd "scenario$n" && docker-compose up
  fi
}

if [ $# -lt 1 ]; then
    usage
fi

main "$@"
