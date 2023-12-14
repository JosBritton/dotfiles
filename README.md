# dotfiles

My dotfiles.

## Intalling
- Scripts:
    `mkdir -p ~/.local/bin/ && ln -s "$(realpath scripts/switchproj)" ~/.local/bin/switchproj`
- Tmux:
    `mkdir -p ~/.config/tmux/ && ln -s "$(realpath tmux/tmux.conf)" ~/.config/tmux/tmux.conf`
- Foot:
    `mkdir -p ~/.config/foot/ && ln -s "$(realpath foot/foot.ini)" ~/.config/foot/foot.ini`
- Neovim:
    `mkdir -p ~/.config/nvim/ && git clone https://github.com/JoeeBritton/nvim-rc.git ~/.config/nvim/`
- Thunderbird:
    `ln -s "$(realpath thunderbird/user.js)" ~/.thunderbird/<PROFILE>/user.js`
- ZSH:
    `ln -s "$(realpath zsh/.zshrc)" ~/.zshrc`
