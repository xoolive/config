unamestr=`uname`

if [[ $unamestr == 'Linux' ]]; then
    alias ls="ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable"
fi

if [[ $unamestr == 'Darwin' ]]; then
    alias ls="ls -G"
fi

alias ll="ls -l"
alias lsn="ls --color=no"

alias fix='reset; stty sane; tput rs1; clear; echo -e "\033c"'
alias rmswp="find . -name '.*.sw[op]' | xargs rm"

alias psu="ps -U $USER"
alias psuf="ps -f -U $USER"

alias pupdatedb="updatedb -l 0 -U $HOME --output=$HOME/.mydb.db"
alias plocate="locate -d $HOME/.mydb.db"

alias -g G="| grep"
alias -g L="| less"
alias -g S="| sed"
alias -g X="| xargs"

unalias news
