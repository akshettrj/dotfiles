bindkey -v
export KEYTIMEOUT=1

# Edit command in vim buffer
autoload edit-command-line && zle -N edit-command-line
bindkey '^v' edit-command-line
bindkey -M vicmd '^v' edit-command-line

# Vim keybindings in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# Fix backspace bug after switching modes
bindkey '^?' backward-delete-char

# Change cursor shape for different modes
function zle-keymap-select {
    case $KEYMAP in
        vicmd) echo -n '\e[1 q';;
        viins|main) echo -n '\e[5 q';;
    esac
}
zle -N zle-keymap-select

# ci", ci', ci`, di", etc
autoload -U select-quoted && zle -N select-quoted
for m in visual viopp
do
    for c in {a,i}{\',\",\`}
    do
        bindkey -M $m $c select-quoted
    done
done

# ci(, ci{, ci<, di(, etc
autoload -U select-bracketed && zle -N select-bracketed
for m in visual viopp
do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}
    do
        bindkey -M $m $c select-bracketed
    done
done

# Set default mode and cursor
zle-line-init() {
    zle -K viins
    echo -ne '\e[5 q'
}
zle -N zle-line-init
preexec() {
    echo -ne '\e[5 q'
}
