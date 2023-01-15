#===============================================================================
#
#         FILE:  functions.sh
#
#  DESCRIPTION:  Shared functions
#
#       AUTHOR:  jvzantvoort (John van Zantvoort), john@vanzantvoort.org
#      CREATED:  2023-01-15
#
#===============================================================================
# Variables: switchable {{{
declare DEBUG="yes"
# }}}

# Constants: Screen measurements {{{
# Get screenwidth
SCREENWIDTH="$(tput cols)"
SCREENWIDTH="$((SCREENWIDTH-(SCREENWIDTH%40)))"
[[ "${SCREENWIDTH}" -lt 80 ]] && SCREENWIDTH=80

MSG_PADSTR_LEN="${SCREENWIDTH}"
MSG_FORMAT="%-${SCREENWIDTH}s [ %s%-7s%s ]\n"
unset SCREENWIDTH

readonly MSG_PADSTR_LEN
readonly MSG_FORMAT
# }}}

# Constants: Screen colors {{{
COLOR_RED=$(tput -Tansi setaf 1)
COLOR_GREEN=$(tput -Tansi setaf 2)
COLOR_GREY=$(tput -Tansi setaf 072)
COLOR_YELLOW=$(tput -Tansi setaf 11)
COLOR_ORANGE=$(tput -Tansi setaf 208)
COLOR_RESET=$(tput -Tansi sgr0)

readonly COLOR_RED
readonly COLOR_GREEN
readonly COLOR_GREY
readonly COLOR_YELLOW
readonly COLOR_ORANGE
readonly COLOR_RESET
# }}}

# Functions: messages {{{
#shellcheck disable=SC2034
function strrep() { for x in $(seq 1 "${1}"); do printf "-"; done; }

function print_msg()
{
  local color=$1; shift
  local state=$1; shift
  local msg="$*"
  local pad
  pad="${#msg}" # length of the string
  pad="$((MSG_PADSTR_LEN-pad))" # subtract it from then screen width
  padstr="$(strrep "${pad}")" # create padding

  #shellcheck disable=SC2059
  printf "${MSG_FORMAT}" "$msg ${padstr}" "${color}" "${state}" "${COLOR_RESET}"
}
function print_title()   { print_msg "${COLOR_GREY}"   "-------" "$@"; }
function print_ok()      { print_msg "${COLOR_GREEN}"  "SUCCESS" "$@"; }
function print_nok()     { print_msg "${COLOR_RED}"    "FAILURE" "$@"; }
function print_fatal()   { print_msg "${COLOR_RED}"    "FATAL"   "$@"; }
function print_warning() { print_msg "${COLOR_ORANGE}" "WARNING" "$@"; }
function print_unknown() { print_msg "${COLOR_YELLOW}" "UNKNOWN" "$@"; }
function print_debug()
{
  [[ "${DEBUG}" != "yes" ]] && return 0
  printf "%s%s%s\n" "${COLOR_GREY}" "$*" "${COLOR_RESET}"
}

function test_result()
{
  local retv=$1
  local message=$2
  if [[ "${retv}" == "0" ]]
  then
    print_ok "${message}"
  else
    print_nok "${message}"
  fi
}

function retv_fatal()
{
  local retv=$1
  local message=$2
  if [[ "${retv}" == "0" ]]
  then
    print_ok "${message}"
  else
    print_fatal "${message}"
    exit 1
  fi
}

function die() { retv_fatal 1 "FATAL: $1"; }

function err127()
{
  which "$1" >/dev/null 2>&1
  retv_fatal "$?" "Command $1 is available"
}

# }}}

# Functions: helper functions {{{
function __mkdirp()
{
    local directory="$1"
    local message="create directory ${directory}"
    local retv=0

    if [[ -d "$directory" ]]
    then
      test_result 0 "${message}, not needed"
      return 0
    fi

    mkdir -p "${directory}"
    retv=$?
    test_result "${retv}" "${message}, failed"
    return "${retv}"
}

function __mkstaging_area()
{
  local retv

  STAGING_AREA="$(mktemp -d "build.XXXXXXXXXXX")"
  STAGING_AREA="$(readlink -f "${STAGING_AREA}")" # make it absolute etc.
  retv="$?"

  [[ "${retv}" == 0 ]] || die "Failed to create tempdir: error code ${retv}"

} # end: __mkstaging_area

# }}}

# vim: foldmethod=marker
