function addpk {
    gpg –keyserver subkeys.pgp.net –recv-keys $1
    gpg –armor –export $1 | sudo apt-key add -
}

function activate {
    if [[ -z $1 ]]; then
        echo "Usage: activate [virtualenv/opamroot name]"
        return
    fi
    if [[ `uname -s` = "Darwin" ]]; then
        if [[ -d $HOME/Library/virtualenv/$1 ]]; then
            source $HOME/Library/virtualenv/$1/bin/activate
        elif [[ -d $HOME/Library/opam/$1 ]]; then
            eval `opam config env --root=$HOME/Library/opam/$1`
        else
            echo "$1 not found"
        fi
    fi
    if [[ `uname -s` = "Linux" ]]; then
        if [[ -d $HOME/.virtualenv/$1 ]]; then
            source $HOME/.virtualenv/$1/bin/activate
        elif [[ -d $HOME/.opamenv/$1 ]]; then
            eval `opam config env --root=$HOME/.opamenv/$1`
        else
            echo "$1 not found"
        fi
    fi
}

if [[ `uname -s` = "Darwin" ]]; then
    local envdirs
    envdirs=($HOME/Library/virtualenv $HOME/Library/opam)
    compdef '_files -W envdirs' activate
fi

if [[ `uname -s` = "Linux" ]]; then
    local envdirs
    envdirs=($HOME/.virtualenv $HOME/.opamenv)
    compdef '_files -W envdirs' activate
fi

function unpack {

    # unpack: Extract common file formats
    # Dependencies: unrar, unzip, p7zip-full
    # Author: Patrick Brisbin

    # Display usage if no parameters given
    if [[ -z "$@" ]]; then
        echo "${0##*/} <archive> - extract common file formats"
        return
    fi

    # Required program(s)
    req_progs=(7zr unrar unzip)
    for p in ${req_progs[@]}; do
        hash "$p" 2>&- || \
        { echo >&2 "Required program \"$p\" not installed."; return; }
    done

    # Test if file exists
    if [ ! -f "$@" ]; then
        echo "File "$@" doesn't exist"
        return
    fi

    # Extract file by using extension as reference
    case "$@" in
        *.7z ) 7zr x "$@" ;;
        *.tar.bz2 ) tar xvjf "$@" ;;
        *.bz2 ) bunzip2 "$@" ;;
        *.deb ) ar vx "$@" ;;
        *.tar.gz ) tar xvzf "$@" ;;
        *.gz ) gunzip "$@" ;;
        *.tar ) tar xvf "$@" ;;
        *.tbz2 ) tar xvjf "$@" ;;
        *.tar.xz ) tar xvf "$@" ;;
        *.tgz ) tar xvzf "$@" ;;
        *.rar ) unrar x "$@" ;;
        *.zip ) unzip "$@" ;;
        *.Z ) uncompress "$@" ;;
        * ) echo "Unsupported file format" ;;
    esac
}

compdef '_files -g "*.{7z,tar.bz2,bz2,deb,tar.gz,gz,tar,tbz2,tax.xz,tgz,rar,zip,Z}"' unpack


function twhich {
    output=$(type -S $1) || {echo >&2 "$output" && return 1;}
    echo "$output" | tr ' ' '\n' | tail -n 1
}

# I like it!
autoload -U zmv

