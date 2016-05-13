#!/bin/bash
# POSIX

# Error handling.
# $1 - error string
die() {
  echo "${0##*/}: error: $*" >&2
  exit 1
}

# As the name suggests
usage() {
  echo "Usage: ${0##*/}  [-h] [ --onezone  | --oneprovider ] [ --onezone_ip ] [ -n  | --node ]

This script starts Onedata components:

Example usage:
${0##*/} --oneprovider -n2
will start a second node of oneprovider service.

Options:
  -h, --help       display this help and exit
  --onezone        starts onezone service
  --onezone_ip     ip or hostname of onezone service
  --oneprovider    starts oneprovider  service
  -n, --node       a node number to start, default value is 1"
  exit 0
}


main() {
  local n=1
  local service
  local onezone_ip

  while [[ $# > 0 ]]; do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit 0
              ;;
          --onezone)       # specify scenari number
              service="onezone"
              ;;
          --oneprovider)       # specify scenari number
              service="oneprovider"
              ;;
          -n|--node)       # specify service name
              n=$2
              shift
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

  ONEZONE_IP="$onezone_ip" docker-compose -f "docker-compose-${service}.yml" up "node${n}.${service}.onedata.example.com"
  
}

if [ $# -lt 1 ]; then
    usage
fi

main "$@"
