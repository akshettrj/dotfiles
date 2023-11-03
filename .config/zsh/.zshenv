COMMON_ENV_FILE=$HOME/.config/shellconfig/_noload_environment
[ -f "$COMMON_ENV_FILE" ] && source "$COMMON_ENV_FILE"

export FPATH="$ZDOTDIR/my_fpath:$FPATH"
