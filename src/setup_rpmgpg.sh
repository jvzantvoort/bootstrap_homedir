#!/bin/bash

# Description: Setup gpg keys for rpm development

# Variables: switchable {{{
#shellcheck disable=SC2034
declare DEBUG="no"
# }}}

# Constants: base {{{
C_SCRIPTPATH="$(readlink -f "$0")"
C_SCRIPTDIR="$(dirname "${C_SCRIPTPATH}")"
C_GNUPGDIR="${HOME}/.gnupg"

readonly C_SCRIPTPATH
readonly C_SCRIPTDIR
readonly C_GNUPGDIR
# }}}

C_SUBDIRS=$(cat <<-END_SUBDIRS
%echo Generating a standard key
Key-Type: DSA
Key-Length: 1024
Subkey-Type: ELG-E
Subkey-Length: 1024
Name-Real: NAME
Name-Comment: COMMENT
Name-Email: EMAIL
Expire-Date: 0
%pubring OUTPUTFILE.pub
%secring OUTPUTFILE.sec
%commit
%echo done
END_SUBDIRS
)

if [[ ! -r "${C_SCRIPTDIR}/functions.sh" ]]
then
  printf "Cannot access shared functions\n\n"
  exit 1
fi
source "${C_SCRIPTDIR}/functions.sh"


function create_gpg_batch_file()
{
  local BASEDIR=$1; shift
  local NAME=$1; shift
  local COMMENT=$1; shift
  local EMAIL=$1; shift
  local OUTPUTFILE=$1; shift

  local BATCHFILE="${BASEDIR}/batch.txt"
  if [[ -f "${BASEDIR}/batch.txt" ]]
  then
    test_result 1 "Batch file should not exist"
    return 1
  else
    test_result 0 "Batch file should not exist"
  fi

  __mkdirp "${BASEDIR}"

  pushd "${BASEDIR}" >/dev/null 2>&1 || die "chdir"
  echo "${C_SUBDIRS}" | \
    sed "s,NAME,${NAME},g" | \
    sed "s,COMMENT,${COMMENT},g" | \
    sed "s,OUTPUTFILE,${OUTPUTFILE},g" | \
    sed "s,EMAIL,${EMAIL},g" >"${BATCHFILE}"
  popd >/dev/null 2>&1 || die "chdir"
}

function generate_gpg_keys()
{
  local BASEDIR=$1; shift
  local OUTPUTFILE=$1; shift

  local BATCHFILE="${BASEDIR}/batch.txt"
  [[ -f "${OUTPUTFILE}.pub" ]] && return
  [[ -f "${OUTPUTFILE}.sec" ]] && return
  [[ -f "${BASEDIR}/batch.txt" ]] || return 1

  pushd "${BASEDIR}" >/dev/null 2>&1 || die "chdir"
  gpg --gen-key --batch "${BASEDIR}/batch.txt"
  retv_fatal "$?" "Generate gpg keys from batch file"
  popd >/dev/null 2>&1 || die "chdir"

  ! test -f "${OUTPUTFILE}.pub"
  retv_fatal "$?" "${OUTPUTFILE}.pub exists"

  ! test -f "${OUTPUTFILE}.sec"
  retv_fatal "$?" "${OUTPUTFILE}.sec exists"

}

function import_gpg_key()
{

  local BASEDIR=$1; shift
  local OUTPUTFILE=$1; shift

  [[ -f "${OUTPUTFILE}.pub" ]] || return 4
  [[ -f "${OUTPUTFILE}.sec" ]] || return 5

  pushd "${BASEDIR}" >/dev/null 2>&1 || die "chdir"
  gpg --import "${OUTPUTFILE}.pub" || return 6
  gpg --import "${OUTPUTFILE}.sec" || return 7
  popd >/dev/null 2>&1 || die "chdir"

}

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

err127 gpg

G_BASEDIR="${C_GNUPGDIR}/batch"
G_NAME="Company Packager"
G_COMMENT="packager"
G_EMAIL="packager@company.com"
G_OUTPUTFILE="${G_COMMENT}"

printf "Name (%s): " "${G_NAME}"
read -r answer
[[ -n "${answer}" ]] && G_NAME="${answer}"

printf "Comment (%s): " "${G_COMMENT}"
read -r answer
[[ -n "${answer}" ]] && G_COMMENT="${answer}"

printf "Email (%s): " "${G_EMAIL}"
read -r answer
[[ -n "${answer}" ]] && G_EMAIL="${answer}"

create_gpg_batch_file "${G_BASEDIR}" "${G_NAME}" "${G_COMMENT}" "${G_EMAIL}" \
  "${G_OUTPUTFILE}"
retv_fatal "$?" "Create gpg batch file"

generate_gpg_keys "${G_BASEDIR}" "${G_OUTPUTFILE}"
retv_fatal "$?" "Create gpg batch file"

gpg --export -a "${G_NAME}" >"${HOME}/RPM-GPG-KEY-${G_OUTPUTFILE}"
RETV="$?"

if [[ "${RETV}" == "0" ]]
then
  test -s "${HOME}/RPM-GPG-KEY-${G_OUTPUTFILE}"
  RETV="$?"
fi
retv_fatal "$RETV" "Export GPG Key to ${HOME}/RPM-GPG-KEY-${G_OUTPUTFILE}"

import_gpg_key "${G_BASEDIR}" "${G_OUTPUTFILE}"
retv_fatal "$?" "Import GPG Keys"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
