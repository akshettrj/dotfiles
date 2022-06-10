autoload -U compinit && compinit -U
zmodload zsh/complist

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=*r:|=*'
zstyle ':completion:*' special-dirs false
zstyle ':completion::complete:*' gain-privileges 1

zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format "%F{yellow}%B--- %d%f%b"
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format "%F{red}%BNo matches for:%b%f %d"
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
zstyle ':completion:*' group-name ''

# Shift + Tab to go back
bindkey -M menuselect '^[[Z' reverse-menu-complete

_comp_options+=(globdots)
