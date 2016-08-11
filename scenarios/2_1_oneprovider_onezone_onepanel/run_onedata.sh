#!/bin/bash

# Scenario has to be defined before the source
SCENARIO_NAME='21oneprovideronezoneonepanel'

source ../../bin/run_onedata.sh 

clean_scenario() {
	: # pass
}

main "$@"