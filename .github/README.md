# Dotfiles

This repository contains my configurations and scripts for various applications I use (listed below) for easy and quick setup in case something happens to my Linux Installation.

## Configuration

* **OS**: [Arch Linux 😎](https://archlinux.org)

## Couple of things

* From `/etc/pulse/default.pa`, remove the line that loads the cork module
```
### Cork music/video streams when a phone stream is active
load-module module-role-cork
```
This will stop Skype/Teams to mute the other sound sources when you join a call.
* Add the following line to `/etc/zsh/zshenv`
```sh
export ZDOTDIR="$HOME/.config/zsh"
```
This way the zsh config files won't clutter your home directory
