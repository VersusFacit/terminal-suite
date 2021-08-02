
usage() {
  1>&2 echo "Usage: $0 [-v | -vv | --verbose | --very-verbose]"
  exit 2
}

positional_params=''
while [ "$#" -gt 0 ]; do
  case "$1" in
    -v|--verbose)
      if [ -n "${VERBOSITY}" ]; then usage; fi
      VERBOSITY='1'
      shift
      ;;
    -vv|--very-verbose)
      if [ -n "${VERBOSITY}" ]; then usage; fi
      VERBOSITY='2'
      shift
      ;;
    -*|--*=) # unsupported flags
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
