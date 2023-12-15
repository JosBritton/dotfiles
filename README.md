# dotfiles

My dotfiles.

## Intalling
- Scripts:
    `ln -s "$(realpath scripts/switchproj)" ~/.local/bin/switchproj`
    `ln -s "$(realpath scripts/scratchtmux)" ~/.local/bin/scratchtmux`
- Tmux:
    `mkdir -p ~/.config/tmux/ && ln -s "$(realpath tmux/tmux.conf)" ~/.config/tmux/tmux.conf`
- Foot:
    `mkdir -p ~/.config/foot/ && ln -s "$(realpath foot/foot.ini)" ~/.config/foot/foot.ini`
- Neovim:
    `ln -s "$(realpath nvim/)" ~/.config/`
- Thunderbird:
    `ln -s "$(realpath thunderbird/user.js)" ~/.thunderbird/<PROFILE>/user.js`
- ZSH:
    `ln -s "$(realpath zsh/.zshrc)" ~/.zshrc`
    `ln -s "$(realpath zsh/.zprofile)" ~/.zprofile`
