#!/bin/bash

# Scenario has to be defined before the source
SCENARIO_NAME='30oneprovideronezonemultihost'

source ../../bin/run_onedata.sh 

PROVIDER_COMPOSE_FILES+=("$PROV_PORTS_CONF" "$PROV_BATCH_CONF")
ZONE_COMPOSE_FILES+=("$ZONE_PORTS_CONF" "$ZONE_BATCH_CONF")

clean_scenario() {
	: # pass
}
echo ${PROVIDER_COMPOSE_FILES[@]/#/-f }

main "$@"