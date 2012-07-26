export EDITOR=vi
export HISTFILE=$HOME/.history
export HISTIGNORE="cd:ls:[bf]g:clear"
export HISTORY=100
export LANG='fr_FR.UTF-8'
export LANGUAGE=fr_FR.UTF-8
export LC_ALL='fr_FR.UTF-8'
export LS_COLORS="no=00:fi=00:di=04;36:ln=01;36:or=01;05;31:pi=40;33:so=01;35:bd=40;33;01:cd=40;33;01:ex=01;32:*.cmd=01;32:*.exe=01;32:*.com=01;32:*.btm=01;32:*.bat=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.tbz=01;31:*.jpg=01;35:*.gif=01;35:*.bmp=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.ps=01;35:"
export SAVEHIST=100

 # Prompt

export PS1="$(print '%{\e[1;32m%}%n%{\e[0m%}') at $(print '%{\e[1;31m%}%m%{\e[0m%}') in $(print '%{\e[1;35m%}%~%{\e[0m%}') "
export PROMPT2="Please end your command ? "            
export PROMPT3="Selection ? "                         
export PROMPT4="Debug > "                            
export SPROMPT="You want to correct it : %U%r%u ? (y/n/e/a)"
export RPROMPT="%T"

