#!/bin/bash

# Description: Setup home subdirs

# Variables: switchable {{{
declare DEBUG="no"
# }}}

# Constants: base {{{
C_SCRIPTPATH="$(readlink -f "$0")"
C_SCRIPTDIR="$(dirname "${C_SCRIPTPATH}")"
C_BUILDNAME="bootstrap_homedir"
readonly C_SCRIPTPATH
readonly C_SCRIPTDIR
readonly C_BUILDNAME
# }}}

if [[ ! -r "${C_SCRIPTDIR}/functions.sh" ]]
then
  printf "Cannot access shared functions\n\n"
  exit 1
fi
source "${C_SCRIPTDIR}/functions.sh"

C_SUBDIRS=$(cat <<-END_SUBDIRS
775 .cache
775 .config
700 .gnupg
700 .local
700 .ssh
755 bin
755 Archive
755 Desktop
755 Documents
755 Downloads
755 rpmbuild
755 rpmbuild/BUILD
755 rpmbuild/BUILDROOT
755 rpmbuild/RPMS
755 rpmbuild/SOURCES
755 rpmbuild/SPECS
755 rpmbuild/SRPMS
775 tmp
755 Workspace
END_SUBDIRS
)

print_title "Setup home subdirs"

echo "${C_SUBDIRS}" | while read -r mode target
do
  if __has_mode "${mode}" "${HOME}/${target}"
  then
    continue
  fi
  __mkdirp "${HOME}/${target}"
  chmod "${mode}" "${HOME}/${target}"
done


#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
