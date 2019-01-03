function addpk {
    gpg –keyserver subkeys.pgp.net –recv-keys $1
    gpg –armor –export $1 | sudo apt-key add -
}

function deactivate {

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
        if [[ -d $HOME/.conda/envs/$1 ]]; then
            source /opt/intel/intelpython3/bin/activate $1
            # switch to a virtualenv-like prompt
            export PS1=$CONDA_PS1_BACKUP
            export VIRTUAL_ENV=$CONDA_DEFAULT_ENV
            export OLD_LD_LIBRARY_PATH=$LD_LIBRARY_PATH
#            export LD_LIBRARY_PATH=/opt/intel/intelpython3/lib/:$LD_LIBRARY_PATH
#            export LD_LIBRARY_PATH=$HOME/.conda/envs/$1/lib/:$LD_LIBRARY_PATH
            function deactivate {
                unset VIRTUAL_ENV
                export LD_LIBRARY_PATH=$OLD_LD_LIBRARY_PATH
                source deactivate
            }
        elif [[ -d $HOME/.virtualenv/$1 ]]; then
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
    envdirs=($HOME/.conda/envs $HOME/.virtualenv $HOME/.opamenv)
    compdef '_files -W envdirs' activate
fi

function twhich {
    output=$(type -S $1) || {echo >&2 "$output" && return 1;}
    echo "$output" | tr ' ' '\n' | tail -n 1
}

function lpresume {
    lpstat | cut -f 1 -d " " | xargs lp -H resume -i
}

# I like it!
autoload -U zmv

