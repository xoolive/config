function addpk {
gpg –keyserver subkeys.pgp.net –recv-keys $1
gpg –armor –export $1 | sudo apt-key add -
}

function activate {
# Play with uname -s
source $HOME/Library/virtualenv/$1/bin/activate
}



