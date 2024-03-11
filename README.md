# dotfiles

My dotfiles.

## Adding dotfiles
1. Add alias to `INSTALL_ALIASES` variable (space delimited).
```make
INSTALL_ALIASES = hyprland waybar tmux gtklock dunst tofi fontconfig \
		  ccache alacritty chromium thunderbird zsh pipewire \
		  neovim steam
```

2. Add entry to `register:` build target.
    ```make
    register:
    	./register "arg1" \	# output directory
    		"arg2" \	# source
    		"arg3" \	# destination
    		"arg4"		# alias
    ```

## Installing

Install the links.

```bash
make install
```

```
...
mkdir -p "/home/user/.config"
ln -sf "/home/user/Sync/dotfiles/config/nvim" "/home/user/.config/nvim"
mkdir -p "/home/user/.steam/steam"
ln -sf "/home/user/Sync/dotfiles/home/steam_dev.cfg" "/home/user/.steam/steam/steam_dev.cfg"
...
```

Check the status of the links.

```bash
make installcheck
```

```
...
./check "/home/user/Sync/dotfiles/config/nvim" "/home/user/.config/nvim"
✔ Pass: /home/user/.config/nvim
./check "/home/user/Sync/dotfiles/home/steam_dev.cfg" "/home/user/.steam/steam/steam_dev.cfg"
✔ Pass: /home/user/.steam/steam/steam_dev.cfg
...
```

## Uninstall

*Note: uninstall may show false-positive errors indictaing that a link
could not be found, this is consistent witht the link not being
installed in the first place and can be disregarded.*

```
make uninstall
```

```
...
unlink: cannot unlink '/home/user/.config/chrome-flags.conf': No such file or directory
make[1]: [/run/user/1000/uninstall.make:16: all] Error 1 (ignored)
unlink "/home/user/.config/nvim"
unlink "/home/user/.steam/steam/steam_dev.cfg"
...
```
