# Return if non-interactive session
[[ $- != *i* ]] && return

autoload -U colors && colors

# History file config
HISTSIZE=100000
SAVESIZE=100000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE

# Files from ~/.config/shellconfig directory
for to_source in $HOME/.config/shellconfig/*
do
    [ -f "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source"
done

# Files from ./source directory
for to_source in $ZDOTDIR/source/*
do
    [ -f "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source"
done

# Plugins from ./plugins directory
for to_source in $ZDOTDIR/plugins/*
do
    [ -d "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source/main.zsh"
done

fpath=($ZDOTDIR/fpath $fpath)

# Misc
setopt COMPLETE_ALIASES
stty stop undef

bindkey '^R' history-incremental-pattern-search-backward
bindkey -s '^l' "^u clear\n"
bindkey -s '^f' "^u fzf\n"
bindkey -s '^o' "^u lfcd\n"

WORDCHARS=''
