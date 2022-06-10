# Dotfiles

My configuration and scripts for various applications for my quick Arch setup.

1. From `/etc/pulse/default.pa`, remove the line that loads the cork module
   ```conf
   load-module module-role-cork
   ```
2. Add the following to `/etc/zsh/zshenv`
   ```sh
   export ZDOTDIR="$HOME/.config/zsh"
   ```
3. For compositor, use `picom-jonaburg-git` from AUR
4. For tty font:
   1. Install: `sudo pacman -S terminus-font`
   2. Put `FONT=ter-d28b.psf.gz` in `/etc/vconsole.conf`
