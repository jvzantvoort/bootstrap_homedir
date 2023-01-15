#!/bin/bash

#------------------------------------------------------------------------------#
#                               setup_golang.sh                                #
#------------------------------------------------------------------------------#

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

if ! which go >/dev/null 2>&1
then
  echo "No go?"
  exit
fi

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

go get github.com/klauspost/asmfmt/cmd/asmfmt@latest
go get github.com/go-delve/delve/cmd/dlv@latest
go get github.com/kisielk/errcheck@latest
go get github.com/davidrjenni/reftools/cmd/fillstruct@master
go get github.com/rogpeppe/godef@latest
go get golang.org/x/tools/cmd/goimports@master
go get golang.org/x/lint/golint@master
go get golang.org/x/tools/gopls@latest
go get github.com/golangci/golangci-lint/cmd/golangci-lint@latest
go get honnef.co/go/tools/cmd/staticcheck@latest
go get github.com/fatih/gomodifytags@latest
go get golang.org/x/tools/cmd/gorename@master
go get github.com/jstemmer/gotags@master
go get golang.org/x/tools/cmd/guru@master
go get github.com/josharian/impl@master
go get honnef.co/go/tools/cmd/keyify@master
go get github.com/fatih/motion@latest
go get github.com/koron/iferr@master

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
