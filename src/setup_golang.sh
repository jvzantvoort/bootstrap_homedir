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

which go >/dev/null 2>&1 || die "Golang is not installed?"

function go_install()
{
  local package="$1"
  local msg
  msg="$(echo "${package}"|cut -d\@ -f1|sed 's,.*\/,,')"
  msg="Install ${msg}"

  go install "${package}"
  test_result "$?" "${msg}"
}

if [[ -e "/etc/centos-release" ]] || [[ -e "/etc/redhat-release" ]]
then
  version=$(cat /etc/*release|grep -E -o "[0-9]\.[0-9][0-9]*"|sort -u)
  if ! which gcc >/dev/null 2>&1
  then
    case "${version}" in
      7.*)
        sudo yum -y groupinstall "Development Tools"
      ;;
      8.*)
        sudo yum -y groupinstall "Development Tools"
      ;;
    esac
  fi
fi

print_title "Setup golang development binaries"

go_install github.com/klauspost/asmfmt/cmd/asmfmt@latest
go_install github.com/go-delve/delve/cmd/dlv@latest
go_install github.com/kisielk/errcheck@latest
go_install github.com/davidrjenni/reftools/cmd/fillstruct@master
go_install github.com/rogpeppe/godef@latest
go_install golang.org/x/tools/cmd/goimports@master
go_install golang.org/x/lint/golint@master
go_install golang.org/x/tools/gopls@latest
go_install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go_install honnef.co/go/tools/cmd/staticcheck@latest
go_install github.com/fatih/gomodifytags@latest
go_install golang.org/x/tools/cmd/gorename@master
go_install github.com/jstemmer/gotags@master
go_install golang.org/x/tools/cmd/guru@master
go_install github.com/josharian/impl@master
go_install honnef.co/go/tools/cmd/keyify@master
go_install github.com/fatih/motion@latest
go_install github.com/koron/iferr@master

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
