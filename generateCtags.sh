#!/usr/bin/env bash
# set up tags which will allow moving to language objects(e.g functions) declarations
# file test operations courtesy of "https://tldp.org/LDP/abs/html/fto.html"
echo "Initializing script..."
dir="$1"

if [ "$#" -eq 1 ]; then
    if [ ! -e "$1" ]; then
        echo "No directory named '$1'"
        exit 1
    fi

    if [[ ! -d "$1" ]]; then
        echo "Expected directory argument, received a file argument"
        exit 1
    fi

    cd "$1"
fi

if ! command -v ctags >/dev/null 2>&1; then
    echo "Installing Universal Ctags..."
    sudo apt-get install -y autoconf pkg-config >/dev/null 2>&1 &&
    git clone https://github.com/universal-ctags/ctags.git >/dev/null 2>&1 &&
    cd ctags &&
    ./autogen.sh >/dev/null 2>&1 &&
    ./configure >/dev/null 2>&1 &&
    make >/dev/null 2>&1 &&
    sudo make install >/dev/null 2>&1 && echo "Installation complete."
else
    echo "Universal Ctags already installed, generating file tags..."
fi

ctags -R --sort=yes --recurse=yes --languages=JavaScript,TypeScript,Python,Go,C \
      --exclude=.git --exclude=BUILD --exclude=.svn --exclude=vendor/* \
      --exclude=node_modules/* --exclude=db/* --exclude=log/* --exclude=dist/* \
      --exclude=.next/* --exclude=out/* --exclude=*.min.js * >/dev/null 2>&1

echo "Tags generated successfully."
