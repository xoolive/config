display_date () {
    echo;
    TZ="America/Los_Angeles" date;
    TZ="America/New_York" date;
    echo "\033[1m$(date -u)\033[0m";
    echo "\033[0;36m$(date)\033[0m";
    TZ="Asia/Tokyo" date;
    TZ="Australia/Sydney" date;
    echo; echo; zle redisplay
}
zle -N display_date


weather () {
    echo
    curl 'wttr.in/Toulouse?format=Moon+phase:+%m'
    echo
    curl 'wttr.in/Toulouse?format=%l+%c%09+%t,+%w'
    echo
    curl 'wttr.in/Delft?format=%l%09+%c%09+%t,+%w'
    echo
    curl 'wttr.in/Kyoto?format=%l%09+%c%09+%t,+%w'
    echo; echo; echo; zle redisplay
}
zle -N weather

my_ip () {
    echo
    echo $(/sbin/ifconfig | grep -e 'inet\>' | tr -s ' ' | cut -d\  -f 3)
    echo; echo; zle redisplay
}
zle -N my_ip

function svg2pdf {
    inkscape -D -z --file=$1 --export-pdf=${1:r}.pdf
}
compdef '_files -g "*.svg"' svg2pdf

function addpk {
    gpg –keyserver subkeys.pgp.net –recv-keys $1
    gpg –armor –export $1 | sudo apt-key add -
}

function twhich {
    output=$(type -S $1) || {echo >&2 "$output" && return 1;}
    echo "$output" | tr ' ' '\n' | tail -n 1
}

function lpresume {
    lpstat | cut -f 1 -d " " | xargs -I {} lp -H resume -i {}
}

# I like it!
autoload -U zmv

