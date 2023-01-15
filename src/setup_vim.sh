#!/bin/bash

# Description: Setup golang development libraries

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

err127 vim
err127 rsync

print_title "Setup vim configuration"

! test -e ~/.vimrc
retv_fatal "$?" "Check for ~/.vimrc"

! test -d ~/.vim
retv_fatal "$?" "Check for ~/.vim"

rsync -a "${C_SCRIPTDIR}/vim/" "${HOME}/.vim/"

ln -s "${HOME}/.vim/main.vim" "$HOME/.vimrc"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
