function addpk {
gpg –keyserver subkeys.pgp.net –recv-keys $1
gpg –armor –export $1 | sudo apt-key add -
}

function activate {
if [[ -z $1 ]]; then
    echo "Usage: activate [virtualenv/opamroot name]"
    return
fi
if [[ `uname -s` -eq "Darwin" ]]; then
    if [[ -d $HOME/Library/virtualenv/$1 ]]; then
        source $HOME/Library/virtualenv/$1/bin/activate
    elif [[ -d $HOME/Library/opam/$1 ]]; then
        eval `opam config env --root=$HOME/Library/opam/$1`
    else
        echo "$1 not found"
    fi
fi
}

if [[ `uname -s` -eq "Darwin" ]]; then
    local envdirs
    envdirs=($HOME/Library/virtualenv $HOME/Library/opam)
    compdef '_files -W envdirs' activate
fi

function vman {
if [[ `uname -s` -eq "Darwin" ]]; then
    mvim -c "SuperMan $*"
else
    gvim -c "SuperMan $*"
fi
if [ "$?" != "0" ]; then
    echo "No manual entry for $*"
fi
}

# I like it!
autoload -U zmv

