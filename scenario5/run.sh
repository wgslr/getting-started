#!/bin/bash

# This script hs to be run from the directory where docker-compose.yml is located
# To exit this scenario and stop all onedata components use CTRL-C in the terminal. 

source ../env
docker-compose up
