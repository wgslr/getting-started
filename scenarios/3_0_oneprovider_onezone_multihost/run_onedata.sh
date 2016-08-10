#!/bin/bash

# Scenario has to be defined before the source
SCENARIO_NAME='30oneprovider_onezone_multihost'

source ../../bin/run_onedata.sh 

clean_scenario() {
	: # pass
}

main "$@"