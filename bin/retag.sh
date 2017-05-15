#!/usr/bin/env bash

# This script is used to update tags in compose files across scenarios and to publish images

docker_tag_exists() {
    local name="$1"
    local tag="$2"
    local token=$(curl -s "https://auth.docker.io/token?service=registry.docker.io&scope=repository:${name}:pull" | cut -d ',' -f 1  | cut -d ":" -f 2 | tr -d '"')
    curl -s -H "Authorization: Bearer $token" -H "Accept: application/json"  "https://index.docker.io/v2/$name/manifests/$tag" | grep -v 'MANIFEST_UNKNOWN'
}

publish() {
  local from="$1"
  local to="$2"
  local shold_we_care_if_image_already_on_docker_hub="$3"
  if [[ "$shold_we_care_if_image_already_on_docker_hub" -eq "0"  ]] && [[ $(docker_tag_exists "${to%%:*}" "${to##*:}") != "" ]]; then 
    echo "INFO: Docker image $to exists in docker hub, skipping docker pull and push"
  else
    docker pull "$from"
    docker tag "$from" "$to"
    docker push "$to"
  fi
}

retag() {
	local component_name="$1"
	local full_name="$2"
	echo "Displaying all old tags for $component_name and runing test sed to see if they get replaced by $full_name"
	find . -type f -iname "docker-compose-*.yml" -exec grep -aHb --color -E "image:\s+\w+/$component_name:.*"  {} \;
	find . -type f -iname "docker-compose-*.yml" -exec sed  -n "s#image:\s\+\(\w\+\)/$component_name:.*#image: $full_name#gp" {} \;

	echo "Retaring and displaying changes"
	find . -type f -iname "docker-compose-*.yml" -exec sed -i "s#image:\s\+\(\w\+\)/$component_name:.*#image: $full_name#g" {} \;
	find . -type f -iname "docker-compose-*.yml" -exec grep -aHb --color -E "image:\s+$full_name"  {} \;
}

usage() { cat <<EOF
Usage: ${0##*/}  [-h] [--nn] [--overwrite] [--oz <onezone source tag or image+tag>] [--oz-to <onezone destination tag or image+tag>]
                 [--op <onezone source tag or image+tag>] [--op-to <onezone destination tag or image+tag>]
                 [--oc <oneclient source tag or image+tag>] [--oc-to <oneclient destination tag or image+tag>]

Example usage:
${0##*/} -nn --op "VFS-1" --oc "VFS-2" --retag --overwrite
${0##*/} --op "docker.onedata.org/oneprovider:VFS-1" --op-to "onedata/oneprovider:nightly-VFS-1" --oc "docker.onedata.org/oneclient:VFS-2" --oc-to "onedata/oneclient:nightly-VFS-2" --retag --overwrite

Those two commands does the same thing: publish and image "docker.onedata.org/oneprovider:VFS-1" to docker hub as "onedata/oneprovider:nightly-VFS-1" and
and image "docker.onedata.org/oneclient:VFS-2" as "donedata/oneclient:nightly-VFS-2"

Options:
  -h,--help         print this help message
  --nn              this flag allows to specify only tag in flags like --oz and --oz-to,
                    it download images of format "docker.onedata.org/onezone:$OZ_FROM"
                    and pushes them to "onedata/onezone:nightly-$OZ_FROM"
                    Think of this flag as a shourtcut.
  --oz              tag or a full domain name and tag of a source Onezone image
  --oz-to           tag or a full domain name and tag of a destination Onezone image
  --op              tag or a full domain name and tag of a source Oneprovider image
  --op-to           tag or a full domain name and tag of a destination Oneprovider image
  --oc              tag or a full domain name and tag of a source Oneclient image
  --oc-to           tag or a full domain name and tag of a destination Oneclient image
  --retag           replace all old tags in all docker compose files in getting started with a new tag
  --overwrite       proceed even if image with a tag exists in the docker hub
EOF
}

main() {

  if (( ! $# )); then
    usage
  fi

  OVERWRITE_DOCKER_IMAGE=0
  while (( $# )); do
      case $1 in
          -h|-\?|--help)   # Call a "usage" function to display a synopsis, then exit.
              usage
              exit 0
              ;;
          --oz)
              OZ_FROM="$2"
              shift
              ;;
          --oz-to)
              OZ_TO="$2"
              shift
              ;;
          --op)
              OP_FROM="$2"
              shift
              ;;
          --op-to)
              OP_TO="$2"
              shift
              ;;
          --oc)
              OC_FROM="$2"
              shift
              ;;
          --oc-to)
              OC_TO="$2"
              shift
              ;;
          --retag)
              RETAG=1
              ;;
          --nn)
              NIGHTLY=1
              ;;
          --overwrite)
              OVERWRITE_DOCKER_IMAGE=1
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

  if [[ $NIGHTLY -eq 1 ]]; then
    [[ ! -z "$OZ_FROM" ]] && OZ_TO="onedata/onezone:nightly-$OZ_FROM" && OZ_FROM="docker.onedata.org/onezone:$OZ_FROM"  
    [[ ! -z "$OP_FROM" ]] && OP_TO="onedata/oneprovider:nightly-$OP_FROM" && OP_FROM="docker.onedata.org/oneprovider:$OP_FROM" 
    [[ ! -z "$OC_FROM" ]] && OC_TO="onedata/oneclient:nightly-$OC_FROM" && OC_FROM="docker.onedata.org/oneclient:$OC_FROM" 
  fi 

  [[ ! -z "$OZ_FROM" ]] && [[ ! -z "$OZ_TO" ]] && publish "$OZ_FROM" "$OZ_TO" "$OVERWRITE_DOCKER_IMAGE"
  [[ ! -z "$OP_FROM" ]] && [[ ! -z "$OP_TO" ]] && publish "$OP_FROM" "$OP_TO" "$OVERWRITE_DOCKER_IMAGE"
  [[ ! -z "$OC_FROM" ]] && [[ ! -z "$OC_TO" ]] && publish "$OC_FROM" "$OC_TO" "$OVERWRITE_DOCKER_IMAGE"

  if [[ $RETAG -eq 1 ]]; then
    [[ ! -z "$OZ_TO" ]] && retag onezone "$OZ_TO"
    [[ ! -z "$OP_TO" ]] && retag oneprovider "$OP_TO"
    [[ ! -z "$OC_TO" ]] && retag oneclient "$OC_TO"
  fi
  exit 0
}

main "$@"