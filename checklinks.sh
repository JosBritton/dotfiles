#!/usr/bin/env sh

err() {
    >&2 echo "Error: $1"
}

testlink() {
    # test cannot have trailing slash
    local file="$(echo "$2" | sed 's/\/$//')"

    if [ ! -f "$file" ] && [ ! -d "$file" ]; then
        err "$2 does not exist"
        return
    fi

    if [ ! -L "$file" ]; then
        err "$2 is not a symlink"
        return
    fi
    
    if [ "$(readlink -f "$2")" != "$1" ]; then
        err "$2 does not link to $1"
        return
    fi
}

testlink "$(realpath scripts/switchproj)" "$HOME/.local/bin/switchproj"
testlink "$(realpath scripts/scratchtmux)" "$HOME/.local/bin/scratchtmux"
testlink "$(realpath tmux/tmux.conf)" "$HOME/.config/tmux/tmux.conf"
testlink "$(realpath foot/foot.ini)" "$HOME/.config/foot/foot.ini"
testlink "$(realpath nvim/)" "$HOME/.config/nvim/"
testlink "$(realpath zsh/.zshrc)" "$HOME/.zshrc"
testlink "$(realpath zsh/.zprofile)" "$HOME/.zprofile"
testlink "$(realpath alacritty/alacritty.yml)" "$HOME/.config/alacritty/alacritty.yml"

tbpath="$(realpath thunderbird/user.js)"
for item in ~/.thunderbird/*; do
    if [ ! -d "$item" ]; then
        continue
    fi
    testlink "$tbpath" "$item/user.js"
done
