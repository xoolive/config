##
 # This file is my personal ~/.zshrc that I can use anywhere
 #
 # Xavier Olive, September 2006
 # xavier@xoolive.org
 ##

# You can uncomment the following line if you want to add the global
# configuration.

# source /etc/zsh/zshrc


source $HOME/.zshenv


 #####
 ##### COMPLETION
 #####

zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin \
                             /usr/sbin /usr/bin /sbin /bin /usr/X11R6/bin
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}'
zstyle ':completion:*' max-errors 3 numeric
zstyle ':completion:*' use-compctl false

#   (from http://www.grml.org/zsh/zsh-lovers.html)

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh.cache
# Prevent CVS files/directories from being completed :
# zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
# zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'
# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
# And if you want the number of errors allowed by _approximate to
# increase with the length of what you have typed so far:
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# Ignore completion functions for commands you don’t have:
zstyle ':completion:*:functions' ignored-patterns '_*'
# With helper functions like:
xdvi() { command xdvi ${*:-*.dvi(om[1])} }
# you can avoid having to complete at all in many cases, but if you do,
# you might want to fall into menu selection immediately and to have the
# words sorted by time:
zstyle ':completion:*:*:xdvi:*' menu yes select
zstyle ':completion:*:*:xdvi:*' file-sort time
# Completing process IDs with menu selection:
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*'   force-list always
# If you end up using a directory as argument, this will remove the
# trailing slash (usefull in ln)
zstyle ':completion:*' squeeze-slashes true
# cd will never select the parent directory (e.g.: cd ../<TAB>):
zstyle ':completion:*:cd:*' ignore-parents parent pwd


# completion:<func>:<completer>:<command>:<argument>:<tag>
[ -f ~/.ssh/config ] && :\
    ${(A)ssh_config_hosts:=${${${${(@M)${(f)"$(<~/.ssh/config)"}:#Host *}#Host }:#*\**}:#*\?*}}

[ -f ~/.ssh/known_hosts ] && :\
    ${(A)ssh_known_hosts:=${${${(f)"$(<$HOME/.ssh/known_hosts)"}%%\ *}%%,*}}

zstyle ':completion:*:*:*' hosts $ssh_config_hosts $ssh_known_hosts

# When completing process IDs I normally want to fall into menu
# selection, too:, but I also want to make sure that I always get the
# list, even if I complete on a command name prefix instead of a PID
# and there is only one possible completion, which is inserted right
# away. This means that the completion system shows me the excerpt
# from the `ps(1)' output for verification that the inserted PID is
# indeed the one of the command I want to kill

zstyle ':completion:*:*:*:*:*' menu yes select
#zstyle ':completion:*:*:*:*:processes' menu yes select
zstyle ':completion:*:*:*:*:processes' force-list always

## on processes completion complete all user processes
zstyle ':completion:*:processes' command 'ps -U$USER'

# formatting and messages
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'%{\e[0;33m%}%d%{\e[0m%}'
zstyle ':completion:*:messages' format $'%{\e[0;33m%}%d%{\e[0m%}'
zstyle ':completion:*:warnings' format\
    $'%{\e[0;33m%}No matches for: %d%{\e[0m%}'
zstyle ':completion:*:corrections' format\
    $'%{\e[0;33m%}%d (errors: %e)%{\e[0m%}'

 #####
 ##### BINDKEY
 #####

bindkey '^R' history-incremental-search-backward
bindkey "^[[H" beginning-of-line                # Home
bindkey "^[[1~" beginning-of-line
bindkey "^[[F" end-of-line                      # End
bindkey "^[[4~" end-of-line
bindkey "^[[3~" delete-char                     # Del
bindkey -e                                      # Emacs (^-^)


 #####
 ##### SETOPT
 #####

setopt ALL_EXPORT             # Comme ca, c'est fait !
setopt APPEND_HISTORY         # Partage l'historique
setopt auto_pushd             # "cd" met le répertoire d'où on vient sur la pile
setopt auto_remove_slash      # Enleve les / inutiles en completion
setopt chase_links            # Traite les liens symboliques comme il faut
setopt correct
setopt correct_all
setopt glob_complete          # Completion avec RegEx
setopt hist_verify            # completion historique (!) intelligente
setopt print_exit_value       # Affiche le code de sortie si différent de '0'
setopt printeightbit
setopt pushd_ignore_dups      # Ignore les doublons dans la pile
setopt pushd_silent           # N'affiche pas la pile après un "pushd" ou "popd"
setopt pushd_to_home          # "pushd" sans argument = "pushd $HOME"

unsetopt bg_nice              # nice(bg_job) = 0
unsetopt clobber              # >| doit etre utilise
unsetopt hup                  # Garde les jobs ouvert si le terminal ferme
unsetopt ignore_eof           # Ctrl+D est équivalent à 'logout'
unsetopt list_ambiguous
unsetopt rm_star_silent       # Demande confirmation pour 'rm *'


 #####
 ##### EXPORT
 #####

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
export PATH=$PATH:/opt/local/bin:/usr/local/bin

 #####
 ##### ALIAS
 #####

alias cd..='cd \.\.'
# alias ls="ls --classify --tabsize=0 --literal --color=auto --show-control-chars --human-readable"
alias ls="ls -G" 
alias ll="ls -l"
alias more="less"
alias fnd="find . -name '\!*'"
alias psu="ps -U `echo $USER`"
alias cls='rm -rf *~ #*'
alias e="emacs -nw"
alias lsn="ls --color=no"
alias sr="screen -r"

alias -g G="| grep"
alias -g X="| xargs"
alias -g L="| less"
alias -g S="| sed"
alias -g A="| awk"
alias -g SU="| sort | uniq"


# CVS alias
# colorize.pl -n20:'M ' -n10:'C ' -n30:'\? ' -n40:'A ' -n60:'P ' -n60:'U '

 #####
 ##### AUTOLOAD
 #####

autoload run-help
autoload -U compinit
compinit
autoload -U zfinit
zfinit
