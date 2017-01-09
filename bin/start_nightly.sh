#!/usr/bin/env bash

# WARNING! This is a development script that is used to start a instance of Onezone on a nightly branch
# it assumes that /etc/hosts is properly configured with FQDN and public ip, and that 
# certificates are present and configured using letsnecrypt

start_onezone() {
  local name=$1
  local fqdn=$2
  echo "Starting Onezone"
  # Uncomment certificate volumes
  sed -i "/OZ_PRIV_KEY_PATH/s/^\(\s*\)#/\1/" docker-compose-onezone.yml
  sed -i "/OZ_CERT_PATH/s/^\(\s*\)#/\1/" docker-compose-onezone.yml
  sed -i "/OZ_CACERT_PATH/s/^\(\s*\)#/\1/" docker-compose-onezone.yml
  OZ_PRIV_KEY_PATH="/volumes/letsencrypt/etc/live/${fqdn}/privkey.pem" \
  OZ_CERT_PATH="/volumes/letsencrypt/etc/live/${fqdn}/cert.pem" \
  OZ_CACERT_PATH="/volumes/letsencrypt/etc/live/${fqdn}/chain.pem" \
  ./run_onedata.sh --zone --name "a" --with-clean --detach
  sh -c 'docker logs -f onezone-1 | { sed "/^Congratulations/ q" && kill $$ ;}'
  pkill -f "docker logs -f onezone-1"
}

start_oneprovider() {
  local name=$1
  local fqdn=$2
  local onezone_address=$3
  echo "Starting Oneprovider"
  # Uncomment certificate volumes
  sed -i "/OP_PRIV_KEY_PATH/s/^\(\s*\)#/\1/" docker-compose-oneprovider.yml
  sed -i "/OP_CERT_PATH/s/^\(\s*\)#/\1/" docker-compose-oneprovider.yml
  sed -i "/OP_CACERT_PATH/s/^\(\s*\)#/\1/" docker-compose-oneprovider.yml
  OP_PRIV_KEY_PATH="/volumes/letsencrypt/etc/live/${fqdn}/privkey.pem" \
  OP_CERT_PATH="/volumes/letsencrypt/etc/live/${fqdn}/cert.pem" \
  OP_CACERT_PATH="/volumes/letsencrypt/etc/live/${fqdn}/chain.pem" \
  ./run_onedata.sh --provider --name "$name" --zone-fqdn "$onezone_address"  --set-lat-long --provider-fqdn "$fqdn" --with-clean --detach
  sh -c 'docker logs -f oneprovider-1 | { sed "/^Congratulations/ q" && kill $$ ;}'
  pkill -f "docker logs -f oneprovider-1"
}

start_oneclient() {
  echo "Starting Oneclient"
  local oneprovider_address=$1
  local onezone_address=$2
  local token
  echo "Error: Oneclient not yet implemented."
  exit 1
}

usage() {
	  echo "TODO
    ./start_nightly.sh --service-name onezone
    ./start_nightly.sh --service-name oneprovider
    ./start_nightly.sh --service-name oneclient"
	  exit 0
}

main() {
  if (( ! $# )); then
    usage
  fi

  default_onezone="in1-mo-onedata.tk"
  default_oneprovider="in2-mo-onedata.tk"
  while (( $# )); do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit 0
              ;;
          --service-name)
              service_to_start="$2"
              shift
              ;;
          --oz-for-op)
              oz_for_op="$2"
              shift
              ;;
          --op-for-oc)
              op_for_oc="$2"
              shift
              ;;
          -?*)
              printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
              exit 1
              ;;
          *)
              echo "no option $1"
              exit 1
              ;;
      esac
      shift
  done
  if [[ ! $service_to_start =~ ^(onezone|oneprovider|oneclient)$ ]]; then
    echo "Error: valid values: onezone, oneprovider or oneclient"
    exit 1
  fi

  MY_DOMAIN=$(hostname -f)


  cd $HOME/nightly-deploy/getting-started/scenarios/3_0_oneprovider_onezone_multihost
  service_id=$(grep "image:" "docker-compose-${service_to_start}.yml" | cut -d '/' -f2)

  [[ "$service_to_start" == "onezone" ]]  && start_onezone "$service_id" "$MY_DOMAIN"

  if [[ "$service_to_start" == "oneprovider" ]]; then
    if [[  -z ${oz_for_op+x} ]]; then 
    	echo "warrning: no onezone address specified, using default value $default_onezone"
    	oz_for_op="$default_onezone"
    fi
    start_oneprovider "$service_id" "$MY_DOMAIN" "$oz_for_op"
  fi

  if [[ "$service_to_start" == "oneclient" ]]; then
    if [[  -z ${op_for_oc+x} ]]; then 
    	echo "warrning: no oneprovider address specified, running oneclient with default $default_oneprovider"
    	op_for_oc="$default_oneprovider"
    fi
    start_oneclient "$service_id" "$MY_DOMAIN" "$op_for_oc"
  fi
  
}

main "$@"






