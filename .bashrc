[[ $- != *i* ]] && return

eval "$(starship init bash)"

COMMON_ENV_FILE="$HOME/.config/shellconfig/_noload_environment"
[ -f "$COMMON_ENV_FILE" ] && source "$COMMON_ENV_FILE"

export HISTFILE=$XDG_CACHE_HOME/bash_history
export HISTSIZE=10000

# Files from ~/.config/shellconfig directory
for to_source in $HOME/.config/shellconfig/*
do
    [ -f "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source"
done

# Files from ~/.config/bash/source
for to_source in $HOME/.config/bash/source/*
do
    [ -f "$to_source" ] || continue
    to_source_bn="$(basename "$to_source")"
    [[ "$to_source_bn" == _noload_* ]] && continue
    source "$to_source"
done

set -o vi
