# Return if non-interactive session
[[ $- != *i* ]] && return

# if (( ${+NO_FISH} )); then
    # echo "Skipping fish jump because NO_FISH is set"
# else
#     exec /opt/homebrew/bin/fish
# fi


autoload -U colors && colors
autoload -Uz compinit && compinit

# History file config
export HISTFILE=$XDG_CACHE_HOME/zsh_history
export HISTSIZE=10000
export SAVEHIST=1000
setopt APPENDHISTORY
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY

# Files from ~/.config/shellconfig directory
for to_source in $HOME/.config/shellconfig/*
do
    # echo "Sourcing $to_source"
    [ -f "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source"
done

# Files from ./source directory
for to_source in $ZDOTDIR/source/*
do
    # echo "Sourcing $to_source"
    [ -f "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source"
done

# Plugins from ./plugins directory
for to_source in $ZDOTDIR/plugins/*
do
    # echo "Loading plugin fom $to_source"
    [ -d "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source/main.zsh"
done

export PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
export PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'

# Misc
setopt COMPLETE_ALIASES
stty stop undef

bindkey '^R' history-incremental-pattern-search-backward
bindkey -s '^l' "^u clear\n"
bindkey -s '^f' "^u fzf\n"
bindkey -s '^o' "^u lfcd\n"

WORDCHARS=''
