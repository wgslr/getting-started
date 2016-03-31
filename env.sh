# Environmental variables for all scenarios
# This file is sourced by every run.sh

# Onezone image version
export ONEZONE_VERSION=VFS-1804
# Onepanel image version
export ONEPROVIDER_VERSION=VFS-1804
# Oneclient image version
export ONECLIENT_VERSION=ID-221cf2c6e6

# First 2 octet of networks that will be created for tutorial scenarios
# in some cases docker internal  network conflicts with host network environment 
# If you experience any connectivity issues change the second value of the address
# eg. 172.40
export NETWORK=172.20
