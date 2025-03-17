eval "$(starship init zsh)"

export PS1=$'%{\e]133;P;k=i\a%}'$PS1$'%{\e]133;B\a\e]122;> \a%}'
export PS2=$'%{\e]133;P;k=s\a%}'$PS2$'%{\e]133;B\a%}'
