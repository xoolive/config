autoload -U compinit zrecompile

if [ -f /etc/zsh_command_not_found ]; then
    source /etc/zsh_command_not_found
fi

autoload run-help
autoload -U compinit
compinit
compdef _gnu_generic R
autoload -U zfinit
zfinit

for zshrc_snipplet in ~/.zsh.d/[0-9][0-9]*[^~] ; do
    source $zshrc_snipplet
done

# OPAM configuration
. $HOME/.opam/opam-init/init.zsh > /dev/null 2> /dev/null || true

