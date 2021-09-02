POETRY_PATH=$(poetry config virtualenvs.path || "")
PIPX_PATH=$(pipx list | grep venvs | sed "s/ /\n/g" | tail -n 1 || "")

function activate {
    if [[ -z $1 ]]; then
        echo "Usage: activate [virtualenv/opamroot name]"
        return
    fi
    if [[ `uname -s` = "Darwin" ]]; then
        if [[ -d $HOME/Library/virtualenv/$1 ]]; then
            source $HOME/Library/virtualenv/$1/bin/activate
        elif [[ -d $PIPX_PATH/$1 ]]; then
            source $PIPX_PATH/$1/bin/activate
        elif [[ -d $POETRY_PATH/$1 ]]; then
            source $POETRY_PATH/$1/bin/activate
        elif [[ -d $HOME/Library/opam/$1 ]]; then
            eval `opam config env --root=$HOME/Library/opam/$1`
        else
            echo "$1 not found"
        fi
    fi
    if [[ `uname -s` = "Linux" ]]; then
        if [[ -d $HOME/.conda/envs/$1 ]]; then
            source /opt/miniconda3/bin/activate $1
        elif [[ -d /opt/miniconda3/envs/$1 ]]; then
            source /opt/miniconda3/bin/activate $1
        elif [[ -d $PIPX_PATH/$1 ]]; then
            source $PIPX_PATH/$1/bin/activate
        elif [[ -d $POETRY_PATH/$1 ]]; then
            source $POETRY_PATH/$1/bin/activate
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
    envdirs=($HOME/Library/virtualenv $PIPX_PATH $POETRY_PATH $HOME/Library/opam)
    compdef '_files -W envdirs' activate
fi

if [[ `uname -s` = "Linux" ]]; then
    local envdirs
    envdirs=(/opt/miniconda3/envs $HOME/.conda/envs $HOME/.virtualenv $PIPX_PATH $POETRY_PATH $HOME/.opamenv)
    compdef '_files -W envdirs' activate
fi

