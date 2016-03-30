#!/bin/bash
# POSIX

# To exit this scenario and stop all onedata components use CTRL-C in the terminal. 

# Reset all variables that might be set
. ./env.sh

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-f OUTFILE] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

    -h, --help       display this help and exit
    -s, --scenario   run specified scenario
EOF
}

n=0
service=""

while [[ $# > 0 ]]
do
    case $1 in
        -h|-\?|--help)   # Call a "show_help" function to display a synopsis, then exit.
            show_help
            exit
            ;;
        --scenario)       # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                n=$2
                shift
            else
                printf 'ERROR: "--scenario" requires a non-empty option argument.\n' >&2
                exit 1
            fi
            ;;
        --service)       # Takes an option argument, ensuring it has been specified.
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

if [ "$service" != "" ]; then
    cd "scenario$n" && docker-compose up "$service"
else
    cd "scenario$n" && docker-compose up
fi

