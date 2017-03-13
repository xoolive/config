## git
#!/bin/zsh
##
## This file was written by Bart Trojanowski <bart@jukie.net>
##
## documented on my blog:
##   http://www.jukie.net/~bart/blog/tag/zsh
##
## references
##   http://www.zsh.org/mla/users/2006/msg01196.html
##   http://dotfiles.org/~frogb/.zshrc
##   http://kriener.org/articles/2009/06/04/zsh-prompt-magic
#



setopt prompt_subst

autoload add-zsh-hook
autoload colors
colors

autoload -Uz vcs_info


# For pretty print of virtualenv
export VIRTUAL_ENV_DISABLE_PROMPT=yes

function virtenv_indicator {
# First for Python
    if [[ -z $VIRTUAL_ENV ]] then
        psvar[1]=''
    else
        psvar[1]=${VIRTUAL_ENV##*/}
    fi
# Then for OCaml
    if [[ -z $OPAMROOT ]] then
        psvar[2]=''
    else
        psvar[2]=${OPAMROOT##*/}
    fi
}
add-zsh-hook precmd virtenv_indicator


# -------------------------------
# # define core prompt functions
#
# # set some colors
for COLOR in RED GREEN BLUE YELLOW WHITE BLACK CYAN MAGENTA; do
    eval PR_$COLOR='%{$fg[${(L)COLOR}]%}'
    eval PR_BRIGHT_$COLOR='%{$fg_bold[${(L)COLOR}]%}'
done
PR_RST="%{${reset_color}%}"
PR_RESET="%{%b%s%u$reset_color%}"
PR_BG="%{%(?.$PR_RESET.%S)%}"

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stangedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
FMT_BRANCH="${PR_YELLOW}%b%u%c${PR_RST} " # e.g. master¹²
FMT_ACTION="(${PR_CYAN}%a${PR_RST}%) "   # e.g. (rebase-i)
# FMT_PATH="%R${PR_YELLOW}/%S"              # e.g. ~/repo/subdir

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr   '?'
zstyle ':vcs_info:*:prompt:*' stagedstr     '+'
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   "" "%~"

function lprompt {
    local brackets=$1
    local color1=$2
    local color2=$3
    local color3=$4

    local bracket_open="${color1}${brackets[1]}${PR_BG}"
    local bracket_close="${color1}${brackets[2]}${PR_RESET}"

    local git='$vcs_info_msg_0_'
    #local cwd="${color2}%B%1~%b"
    local userhost="${PR_RESET}${color1}%n${PR_WHITE} at ${PR_BG}${color2}%m${PR_RESET}"
    local cwd=" in ${color3}%~"

    local vimode='${PR_VIMODE}'
    local vicol='${PR_VICOLOR}'

    PROMPT="${bracket_open}${userhost}${cwd}${bracket_close}
${color1}%(1V.(%1v) .)${color3}%(2V.(%2v) .)${git}${vicol}${vimode}${PR_RESET} "

}

function rprompt {
    local brackets=$1
    local color1=$2
    local color2=$3

    local bracket_open="${color1}${brackets[1]}${PR_RESET}"
    local bracket_close="${color1}${brackets[2]}${PR_RESET}"
#    local colon="${color1}:"
#    local at="${color1}@${PR_RESET}"

#    local user_host="${color2}%n${at}${color2}%m"
#    local vcs_cwd='${${vcs_info_msg_1_%%.}/$HOME/~}'
#    local cwd="${color2}%B%20<..<${vcs_cwd}%<<%b"
#    local inner="${user_host}${colon}${cwd}"
    local localtime="${color2}%T${PR_RESET}"

    RPROMPT="${bracket_open}${localtime}${bracket_close}${PR_RESET}"
}

#if [ -n "$debian_chroot" ]; then
#    PROMPT="$bgc%{$fg[yellow]%}%B${debian_chroot}%b ${PROMPT}"
#fi

if [ $UID -eq 0 ]; then
    lprompt '<>' $PR_RED $PR_RED $PR_RED
    rprompt '<>' $PR_RED $PR_RED
else
    case $HOST in
        *)
            lprompt '' $PR_BRIGHT_GREEN $PR_BRIGHT_RED $PR_BRIGHT_MAGENTA
            rprompt '[]' $PR_GREEN $PR_BRIGHT_GREEN
            ;;
    esac
fi


# This variable dictates weather we are going to do the git prompt update
# before printing the next prompt.  On some setups this saves 10s of work.
export PR_GIT_UPDATE=1

# called before command excution
# here we decide if we should update the prompt next time
function zsh_git_prompt_preexec {
        case "$(history $HISTCMD)" in
            *git*)
                PR_GIT_UPDATE=1
                ;;
        esac
}
add-zsh-hook preexec zsh_git_prompt_preexec

# called after directory change
# we just assume that we have to update git prompt
function zsh_git_prompt_chpwd {
        PR_GIT_UPDATE=1
}
add-zsh-hook chpwd zsh_git_prompt_chpwd

# called before prompt generation
# if needed, we will update the prompt info
function zsh_git_prompt_precmd {
       if [[ -n "$PR_GIT_UPDATE" ]] ; then
               vcs_info 'prompt'
               PR_GIT_UPDATE=
       fi
}
add-zsh-hook precmd zsh_git_prompt_precmd

# ------------------------------
# handle vi NORMAL/INSERT mode change
PR_VIMODE="#"
PR_VICOLOR=${PR_BLUE}
function zle-line-init zle-keymap-select {
        PR_VIMODE="${${KEYMAP/vicmd/¢}/(main|viins)/$}"
        PR_VICOLOR="${${KEYMAP/vicmd/${PR_RED}}/(main|viins)/${PR_GREEN}}"
        zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# ------------------------------
# this stuff updates screen and xterm titles as the command runs

case $TERM in
    xterm* | rxvt* | urxvt*)
        function zsh_term_prompt_precmd {
                print -Pn "\e]0;%n@%m: %~\a"
        }
        function zsh_term_prompt_preexec {
                local x="${${${1//\"/\\\"}//\$/\\\\\$}//\%/%%}"
                print -Pn "\e]0;%n@%m: %~  $x\a"
        }
        add-zsh-hook preexec zsh_term_prompt_preexec
        add-zsh-hook precmd zsh_term_prompt_precmd
        ;;
    screen*)
        function zsh_term_prompt_precmd {
                print -nR $'\033k'"zsh"$'\033'\\\

                print -nR $'\033]0;'"zsh"$'\a'
        }
        function zsh_term_prompt_preexec {
                local x="${${${1//\"/\\\"}//\$/\\\\\$}//\%/%%}"
                print -nR $'\033k'"$x"$'\033'\\\

                print -nR $'\033]0;'"$x"$'\a'
        }
        add-zsh-hook preexec zsh_term_prompt_preexec
        add-zsh-hook precmd zsh_term_prompt_precmd
        ;;
esac

