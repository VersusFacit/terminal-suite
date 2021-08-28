#!/bin/bash

usage() {
  1>&2 echo "Usage: $0 [-v | --verbose | -q | --quiet]"
  exit 2
}

exec 3> ./build.log

positional_params=''
while [ "$#" -gt 0 ]; do
  case "$1" in
    -v|--verbose)
      [ -n "${VERBOSITY}" ] && usage
      VERBOSITY='high'
      exec 3>&1
      shift
      ;;
    -q|--quiet)
      [ -n "${VERBOSITY}" ] && usage
      VERBOSITY='low'
      exec 1> ./build.log
      exec 3>&1
      shift
      ;;
    -*) # unsupported flags
      1>&2 echo "Error: Unsupported flag $1"
      usage
      ;;
    *)
      positional_params="${positional_params} $1"
      shift
      ;;
  esac
done

# per https://medium.com/@Drew_Stokes/bash-argument-parsing-54f3b81a6a8f
#   invoke this to retain true positional parameters
eval set -- "${positional_params}"
unset positional_params
