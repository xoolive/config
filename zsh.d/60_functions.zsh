function addpk {
gpg –keyserver subkeys.pgp.net –recv-keys $1
gpg –armor –export $1 | sudo apt-key add -
}

function activate {
if [[ -z $1 ]]; then
    echo "Usage: activate [virtualenv name]"
    return
fi
if [[ `uname -s` -eq "Darwin" ]]; then
    source $HOME/Library/virtualenv/$1/bin/activate
fi
}

if [[ `uname -s` -eq "Darwin" ]]; then
    compdef '_files -W $HOME/Library/virtualenv' activate
fi

# I like it!
autoload -U zmv

