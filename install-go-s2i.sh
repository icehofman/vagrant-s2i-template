#!/bin/bash

VERSION="1.10.2"
OS="linux"
ARCH="amd64"
FILE="go$VERSION.$OS-$ARCH.tar.gz"
URL="https://storage.googleapis.com/golang/$FILE"
HOMEPATH="/home/vagrant"

sudo apt-get update
sudo apt-get install -y git curl wget

if [ ! -f "$HOMEPATH/go.tar.gz" ]; then

	echo "Downloading $FILE ..."
	curl --silent $URL -o "$HOMEPATH/go.tar.gz"

fi;

if [ ! -d "$HOMEPATH/.go" ]; then

    echo "Extracting ..."
    tar -C "$HOMEPATH" -xzf "$HOMEPATH/go.tar.gz"
    mv "$HOMEPATH/go" "$HOMEPATH/.go"
    
    GP="/vagrant/gopath"
    mkdir -p "$GP/src"
    mkdir -p "$GP/pkg"
    mkdir -p "$GP/bin"
    
    echo "Editing .bashrc ..."
    touch "$HOMEPATH/.bashrc"
    {
	    echo '# Prompt'
	    echo 'export PROMPT_COMMAND=_prompt'
	    echo '_prompt() {'
	    echo '    local ec=$?'
	    echo '    local code=""'
	    echo '    if [ $ec -ne 0 ]; then'
	    echo '        code="\[\e[0;31m\][${ec}]\[\e[0m\] "'
	    echo '    fi'
	    echo '    PS1="${code}\[\e[0;32m\][\u] \W\[\e[0m\] $ "'
	    echo '}'

        echo '# Golang environments'
        echo 'export GOROOT=$HOME/.go'
        echo 'export PATH=$PATH:$GOROOT/bin'
        echo 'export GOPATH=/vagrant/gopath'
        echo 'export PATH=$PATH:$GOPATH/bin'

	    echo '# Automatically change to the vagrant dir'
	    echo 'cd /vagrant'
    } >> "$HOMEPATH/.bashrc"

    echo "Go finished..."

fi;

if [ ! -f "$HOMEPATH/s2i/source-to-image.tar.gz" ]; then

	echo "Downloading source-to-image.tar.gz..."
    mkdir "$HOMEPATH/s2i"
	wget -q https://github.com/openshift/source-to-image/releases/download/v1.1.9a/source-to-image-v1.1.9a-40ad911d-linux-amd64.tar.gz -O "$HOMEPATH/s2i/source-to-image.tar.gz"

fi;

if [ ! -f /usr/local/bin/s2i ]; then

    echo "Extracting source-to-image.tar.gz..."    
    (cd "$HOMEPATH/s2i" && tar -xvf source-to-image.tar.gz)
    sudo cp "$HOMEPATH/s2i/s2i" /usr/local/bin
    echo "S2i finished..."

fi;    

echo "All done!"
