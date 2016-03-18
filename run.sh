#!/bin/sh
# POSIX

# To exit this scenario and stop all onedata components use CTRL-C in the terminal. 

# Reset all variables that might be set
scenario=0 

while :; do
    case $1 in
        -h|-\?|--help)   # Call a "show_help" function to display a synopsis, then exit.
            show_help
            exit
            ;;
        -s|--scenario)       # Takes an option argument, ensuring it has been specified.
            if [ -n "$2" ]; then
                scenario=$2
                shift
            else
                printf 'ERROR: "--scenario" requires a non-empty option argument.\n' >&2
                exit 1
            fi
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: If no more options then break out of the loop.
            break
    esac
    shift
done

# Usage info
show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [-f OUTFILE] [FILE]...
Do stuff with FILE and write the result to standard output. With no FILE
or when FILE is -, read standard input.

    -h          display this help and exit
    -f OUTFILE  write the result to OUTFILE instead of standard output.
    -v          verbose mode. Can be used multiple times for increased
                verbosity.
EOF
}

