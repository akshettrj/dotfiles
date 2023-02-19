# Return if non-interactive session
[[ $- != *i* ]] && return

autoload -U colors && colors

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

fpath=($ZDOTDIR/my_fpath $fpath)
for to_source in $ZDOTDIR/my_fpath/*
do
    [ -d "$to_source" ] || continue
    autoload -U "$to_source"
done

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

# Misc
setopt COMPLETE_ALIASES
stty stop undef

bindkey '^R' history-incremental-pattern-search-backward
bindkey -s '^l' "^u clear\n"
bindkey -s '^f' "^u fzf\n"
bindkey -s '^o' "^u lfcd\n"

WORDCHARS=''


# Xorg Server

_NVIDIA_CONF_SRC="$HOME/.config/X11/10-nvidia-drm-outputclass.conf"
_NVIDIA_CONF_DST="/usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf"

_MONITOR_CONF_SRC="$HOME/.config/X11/10-monitor.conf"
_MONITOR_CONF_DST="/usr/share/X11/xorg.conf.d/10-monitor.conf"

if [[ "$(tty)" == "/dev/tty1" ]]; then
    diff "${_NVIDIA_CONF_SRC}" "${_NVIDIA_CONF_DST}" >/dev/null || sudo cp -f "${_NVIDIA_CONF_SRC}" "${_NVIDIA_CONF_DST}"
    diff "${_MONITOR_CONF_SRC}" "${_MONITOR_CONF_DST}" >/dev/null || sudo cp -f "${_MONITOR_CONF_SRC}" "${_MONITOR_CONF_DST}"
    pgrep awesome || startx "$HOME/.config/X11/Xinitrc_awesome"
elif [[ "$(tty)" == "/dev/tty2" ]]; then
    diff "${_NVIDIA_CONF_SRC}" "${_NVIDIA_CONF_DST}" >/dev/null || sudo cp -f "${_NVIDIA_CONF_SRC}" "${_NVIDIA_CONF_DST}"
    diff "${_MONITOR_CONF_SRC}" "${_MONITOR_CONF_DST}" >/dev/null || sudo cp -f "${_MONITOR_CONF_SRC}" "${_MONITOR_CONF_DST}"
    pgrep bspwm || startx "$HOME/.config/X11/Xinitrc_bspwm"
elif [[ "$(tty)" == "/dev/tty3" ]]; then
    diff "${_NVIDIA_CONF_SRC}" "${_NVIDIA_CONF_DST}" >/dev/null || sudo cp -f "${_NVIDIA_CONF_SRC}" "${_NVIDIA_CONF_DST}"
    diff "${_MONITOR_CONF_SRC}" "${_MONITOR_CONF_DST}" >/dev/null || sudo cp -f "${_MONITOR_CONF_SRC}" "${_MONITOR_CONF_DST}"
    pgrep awesome || startx "$HOME/.config/X11/Xinitrc_xfce4"
fi
