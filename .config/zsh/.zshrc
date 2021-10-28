[[ $- != *i* ]] && return

# neofetch

autoload -U colors && colors	# Load colors

# Keep 10000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=100000
SAVEHIST=100000

export HISTFILE=~/.cache/.zsh_history
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt autopushd

source ~/.config/zsh/spaceship

# command-not-found handler function (use pacman -Fy to update the command-not-found stuff here)

# ===============================================================================

# TAB completion from Brodie
autoload -U compinit
zstyle ':completion:*' menu select
# Case insensitive auto-completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion::complete:*' gain-privileges 1

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.
zstyle ':completion:*' special-dirs false

bindkey -v
export KEYTIMEOUT=1

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char

# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char


# Change cursor shape for different vi modes.
function zle-keymap-select {
    case $KEYMAP in
	vicmd) echo -ne '\e[1 q';;      # block
	viins|main) echo -ne '\e[5 q';; # beam
    esac
}

# ci", ci', ci`, di", etc
autoload -U select-quoted
zle -N select-quoted
for m in visual viopp; do
    for c in {a,i}{\',\",\`}; do
	bindkey -M $m $c select-quoted
    done
done

# ci{, ci(, ci<, di{, etc
autoload -U select-bracketed
zle -N select-bracketed
for m in visual viopp; do
    for c in {a,i}${(s..)^:-'()[]{}<>bB'}; do
	bindkey -M $m $c select-bracketed
    done
done

zle -N zle-keymap-select
zle-line-init() {
zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.

# ================================================================================


# =================================================================================
# GENERAL SHELL CONFIGS

export SHELL_CONFIG_DIR=~/.config/shellconfig

for customConfig in $SHELL_CONFIG_DIR/*
do
    source "$customConfig"
done


# ================================================================================

# Some Key bindings
bindkey '^R' history-incremental-pattern-search-backward
bindkey -s '^s' " fixcur\n keyboardFix\n"
bindkey -s '^l' " clear\n"
bindkey -s '^f' " fzf\n"
WORDCHARS=''

# Directories Hack
setopt auto_cd

stty stop undef		# Disable ctrl-s to freeze terminal.
setopt COMPLETE_ALIASES


# Change directories using lf (file manager)
lfcd() {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
	dir="$(cat "$tmp")"
	rm -f "$tmp" >/dev/null
	[ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}

#================================================

for Dir in /home/akshettrj/.scripts/*
do
    export PATH=$PATH:$Dir
done

#PLUGINS

export ZSH_PLUGINS_DIR=/home/akshettrj/.config/pluginsZsh

for customPlugin in $ZSH_PLUGINS_DIR/*
do
    source "$customPlugin/main.zsh"
done

#PYENV
export PATH="/home/akshettrj/.pyenv/shims:/opt/pyenv/plugins/pyenv-virtualenv/bin:${PATH}";
export PYENV_VIRTUALENV_INIT=1;
_pyenv_virtualenv_hook() {
  local ret=$?
  if [ -n "$VIRTUAL_ENV" ]; then
    eval "$(pyenv sh-activate --quiet || pyenv sh-deactivate --quiet || true)" || true
  else
    eval "$(pyenv sh-activate --quiet || true)" || true
  fi
  return $ret
};
typeset -g -a precmd_functions
if [[ -z $precmd_functions[(r)_pyenv_virtualenv_hook] ]]; then
  precmd_functions=(_pyenv_virtualenv_hook $precmd_functions);
fi

fpath=(~/.config/zsh/completion $fpath)


# Directly starts the X-server upon login on tty1

if [[ "$(tty)" = "/dev/tty1" ]]; then
    # Fix my NVIDIA Card config
    diff /home/akshettrj/.config/10-nvidia-drm-outputclass.conf /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf || sudo cp -f /home/akshettrj/.config/10-nvidia-drm-outputclass.conf /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    clear
    pgrep bspwm || startx $HOME/.config/X11/Xinitrc_bspwm
elif [[ "$(tty)" = "/dev/tty2" ]]; then
    # Fix my NVIDIA Card config
    diff /home/akshettrj/.config/10-nvidia-drm-outputclass.conf /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf || sudo cp -f /home/akshettrj/.config/10-nvidia-drm-outputclass.conf /usr/share/X11/xorg.conf.d/10-nvidia-drm-outputclass.conf
    clear
    pgrep awesome || startx $HOME/.config/X11/Xinitrc_awesome
fi
