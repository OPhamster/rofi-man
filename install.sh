#!/bin/bash

VERSION="0.1"
DOCDIR=docs
PERLPOD=$DOCDIR/rofi-man.pod
MANPAGE=$DOCDIR/rofi-man.7.gz
SECTION=7
RT_DEPENDENCIES=(rofi whatis man bash)
BLD_DEPENDENCIES=(pod2man)
MISSING_MANPAGE="rofi-man: nothing appropriate."

check_dependencies() {
    echo "Checking dependencies..."
    missing_dependency=0
    for dependency in "${RT_DEPENDENCIES[@]}"; do
        if [ -z $(command -v $dependency) ]; then
            echo "Missing Dependency: $dependency"
            missing_dependency=1
        fi
    done
    if [ $missing_dependency -eq 1 ]; then
        echo "Would suggest installing the missing dependencies"
        exit 1
    else
        echo "all dependencies present"
    fi
}

build_docs() {
    echo "Building manpage..."
    pod2man --section $SECTION --center="ROFI-MAN" --release=$VERSION $PERLPOD > $MANPAGE
}

install_docs() {
    # build_docs
    echo "Adding manpage..."
    whatretval=$(whatis rofi-man)
    exitcode=$?
    if [ $exitcode == 16 ]; then
        IFS=':' read -r -a manpaths <<< "$(manpath)"
        for mp in "${manpaths[@]}"
        do
            MANPAGE_INSTALL_DIR="$mp/man$SECTION"
            if [ -d "$MANPAGE_INSTALL_DIR" ]; then
                sudo cp $MANPAGE $MANPAGE_INSTALL_DIR
                sudo mandb
                break
            fi
        done
    elif [ $exitcode -gt 0 ]; then
        echo $whatretval
    else
        echo "manpage already present"
    fi
}

install_bin() {
    echo "Adding executable..."
    if [ -z $(command -v rofi-man) ]; then
        if [ ! -d ~/.local/bin ]; then
            mkdir ~/.local/bin
        fi
        cp rofi-man ~/.local/bin/rofi-man
    else
        echo "executable present"
    fi

    dir_in_path=$(echo $PATH | grep "$HOME/.local/bin" -c)
    if [ $dir_in_path -gt 0 ]; then
        echo "# required by rofi-man" >> ~/.profile
        echo "PATH=\$PATH:\$HOME/.local/bin" >> ~/.profile
    fi

}

if [ $# == 0 ]; then
    check_dependencies
    install_bin
    install_docs
fi
