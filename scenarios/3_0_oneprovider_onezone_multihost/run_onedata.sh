#!/bin/bash

# Scenario has to be defined before the source
SCENARIO_NAME='30oneprovideronezonemultihost'

source ../../bin/run_onedata.sh 

PROVIDER_COMPOSE_FILES+=("$PROV_PORTS_CONF" "$PROV_BATCH_CONF")
ZONE_COMPOSE_FILES=("docker-compose-onezone.yml")
CLIENT_COMPOSE_FILES=("docker-compose-oneclient.yml")

clean_scenario() {
	: # pass
}
echo ${PROVIDER_COMPOSE_FILES[@]/#/-f }

main "$@"