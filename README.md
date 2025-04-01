# Requirements

# Fonts
- JetBrainsMono Nerd Font (Bold Italic Regular)

## Terminal
- alacritty
- kitty

## Shell
- zsh
- oh my zsh
- [zsh syntax highlight](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)

## Editors
- helix

## Python
- pyenv
- pipx
- cargo

## Window managers
- sway

## Tools
- git
- ripgrep
- htop
- batcat
- fzf
- fd-find
- wl-clipboard
- pulseaudio-utils
- grimshot
- delta pager
- neofetch

## Browsers
- firefox

## Fonts

```sh
wget -P ~/.local/share/fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip \
&& cd ~/.local/share/fonts \
&& unzip JetBrainsMono.zip \
&& rm JetBrainsMono.zip \
&& fc-cache -fv
```
