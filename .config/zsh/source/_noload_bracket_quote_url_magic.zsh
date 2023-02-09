# Copied from tpope's config files

autoload -Uz bracketed-paste-magic
zle -N bracketed-paste bracketed-paste-magic

autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

zstyle -e ':url-quote-magic:*' url-seps 'reply=("&${histchars[1]}")' # Remove ";<>"
zstyle ':url-quote-magic:*' url-metas '*?[]^()~#' # Remove "=|{}"
