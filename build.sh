#!/bin/bash

# This script builds the bundle for bootstrap_homedir

# Variables: switchable {{{
declare DEBUG="yes"
# }}}

# Constants: base {{{
C_SCRIPTPATH="$(readlink -f "$0")"
C_SCRIPTDIR="$(dirname "${C_SCRIPTPATH}")"
C_BUILDNAME="bootstrap_homedir"
readonly C_SCRIPTPATH
readonly C_SCRIPTDIR
readonly C_BUILDNAME
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

# Constants: Variable lists {{{
C_VIM_REPOS=$(cat <<-END_VIMREPOS
bundle/Vundle.vim                    https://github.com/VundleVim/Vundle.vim.git
bundle/asyncomplete-lsp.vim          https://github.com/prabirshrestha/asyncomplete-lsp.vim.git
bundle/asyncomplete.vim              https://github.com/prabirshrestha/asyncomplete.vim.git
bundle/async.vim                     https://github.com/prabirshrestha/async.vim.git
bundle/ctrlp.vim                     https://github.com/kien/ctrlp.vim.git
bundle/Jenkinsfile-vim-syntax        https://github.com/martinda/Jenkinsfile-vim-syntax.git
bundle/molokai                       https://github.com/tomasr/molokai.git
bundle/nerdtree                      https://github.com/scrooloose/nerdtree.git
bundle/robotframework-vim            https://github.com/seeamkhan/robotframework-vim.git
bundle/tabular                       https://github.com/godlygeek/tabular.git
bundle/tlib_vim                      https://github.com/tomtom/tlib_vim.git
bundle/vim-addon-mw-utils            https://github.com/MarcWeber/vim-addon-mw-utils.git
bundle/vim-airline                   https://github.com/vim-airline/vim-airline.git
bundle/vim-airline-themes            https://github.com/vim-airline/vim-airline-themes.git
bundle/vim-ansible-yaml              https://github.com/chase/vim-ansible-yaml.git
bundle/vim-colors-solarized          https://github.com/altercation/vim-colors-solarized.git
bundle/vim-devicons                  https://github.com/ryanoasis/vim-devicons.git
bundle/vim-docbk                     https://github.com/jhradilek/vim-docbk.git
bundle/vim-flake8                    https://github.com/nvie/vim-flake8.git
bundle/vim-fugitive                  https://github.com/tpope/vim-fugitive.git
bundle/vim-go                        https://github.com/fatih/vim-go.git
bundle/Vim-Jinja2-Syntax             https://github.com/Glench/Vim-Jinja2-Syntax.git
bundle/vim-lsp                       https://github.com/prabirshrestha/vim-lsp.git
bundle/vim-markdown                  https://github.com/plasticboy/vim-markdown.git
bundle/vim-nerdtree-syntax-highlight https://github.com/tiagofumo/vim-nerdtree-syntax-highlight.git
bundle/vim-scimark                   https://github.com/mipmip/vim-scimark.git
bundle/vim-snipmate                  https://github.com/garbas/vim-snipmate.git
bundle/vim-terraform                 https://github.com/hashivim/vim-terraform.git
bundle/vim-toml                      https://github.com/cespare/vim-toml.git
bundle/vimwiki                       https://github.com/vimwiki/vimwiki.git
END_VIMREPOS
)

readonly C_VIM_REPOS
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

function git_export()
{
  local target="$1"
  local url="$2"
  local reponame

  dirn="$(dirname "${target}")"
  reponame="$(basename "${url}" .git)"

  print_debug "target: ${target}"
  print_debug "url:    ${url}"
  print_debug "dirn:   ${dirn}"

  __mkdirp "${dirn}" || die "mkdir"
  __mkdirp "${STAGING_AREA}/checkouts" || die "mkdir"

  pushd "${STAGING_AREA}/checkouts" >/dev/null 2>&1 || die "chdir: ${STAGING_AREA}/checkouts"
  git clone "${url}" >/dev/null 2>&1
  retv_fatal "$?" "clone archive"

  pushd "${STAGING_AREA}/checkouts/${reponame}" >/dev/null 2>&1 || \
    die "chdir: ${STAGING_AREA}/checkouts/${reponame}"

  git archive --prefix="${reponame}/" HEAD | tar -xf - -C "${dirn}"
  retv_fatal "$?" "export archive"

  popd >/dev/null 2>&1 || die "popd"
  popd >/dev/null 2>&1 || die "popd"

}

function __makeself()
{
  pushd "${C_SCRIPTDIR}" >/dev/null 2>&1 || die "chdir: ${STAGING_AREA}"
  makeself src "${C_BUILDNAME}.run" "${C_BUILDNAME}" "./main" --gzip --nox11 --nowait
  popd  >/dev/null 2>&1 || die "chdir"
}

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

err127 makeself
err127 git
err127 curl
err127 rsync

__mkstaging_area
pushd "${STAGING_AREA}" >/dev/null 2>&1 || die "chdir: ${STAGING_AREA}"

echo "${C_VIM_REPOS}" | while read -r targetdir targeturl
do
  git_export "${STAGING_AREA}/export/vim/${targetdir}" "${targeturl}"
done

rsync -av --delete "${STAGING_AREA}/export/vim/bundle/" "${C_SCRIPTDIR}/src/vim/bundle/"

curl -fLo "${C_SCRIPTDIR}/src/vim/autoload/plug.vim" --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

__makeself

rm -rf "${STAGING_AREA}"


popd >/dev/null 2>&1 || die "chdir: ${OLDPWD}"
#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
# vim: foldmethod=marker
