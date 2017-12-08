unamestr=`uname`
if [[ $unamestr == 'Linux' ]]; then
    alias ls="ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable"
    alias open="xdg-open"
fi
if [[ $unamestr == 'Darwin' ]]; then
    alias ls="ls -G"
fi


alias cd..='cd \.\.'
alias ll="ls -l"
alias more="less"
alias psu="ps -U `echo $USER`"
alias lsn="ls --color=no"
alias rmswp="find . -name '.*.sw[op]' | xargs rm"

alias -g G="| grep"
alias -g L="| less"
alias -g S="| sed"
alias -g X="| xargs"
