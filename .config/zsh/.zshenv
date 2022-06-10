export HISTFILE=$XDG_CACHE_HOME/zsh_history

COMMON_ENV_FILE=$HOME/.config/shellconfig/_noload_environment
[ -f "$COMMON_ENV_FILE" ] && source "$COMMON_ENV_FILE"
