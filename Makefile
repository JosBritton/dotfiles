.DEFAULT_GOAL: install

# CONFIGURATION:
#	1. add alias to list below if you want to have it installed
#	2. register your link under `register:` (follow the comment)

INSTALL_ALIASES = tmux fontconfig ccache alacritty thunderbird zsh pipewire \
		  neovim steam bspwm xinit xorg-nvidia git zathura \
		  xdg-dirs npm fastfetch fd rfv eww convert_hex_xterm red_oxide \
		  syncgs firefox yamllint bash ffmpeg ssh terminate_bg kitty \
		  diff_pager

define INSTALL_TARGET
.PHONY: all
all: $(INSTALL_ALIASES)
endef

define INSTALLCHECK_TARGET
.SILENT:
.PHONY: all
.IGNORE:
all: $(INSTALL_ALIASES)
endef

define UNINSTALL_TARGET
.PHONY: all
.IGNORE: all
all:
endef

.PHONY: install
install: register
	@$(MAKE) -s --no-print-directory -f "$(REGISTER_RUN_DIR)/install.make" all

.PHONY: uninstall
uninstall: register
	@$(MAKE) -s --no-print-directory -f "$(REGISTER_RUN_DIR)/uninstall.make" all

.PHONY: installcheck
installcheck: register
	@$(MAKE) -s --no-print-directory -f "$(REGISTER_RUN_DIR)/installcheck.make" all

XDG_CONFIG_HOME  ?= "$(HOME)/.config"
XDG_DATA_HOME    ?= "$(HOME)/.local/share"
XDG_STATE_HOME   ?= "$(HOME)/.local/state"
XDG_CACHE_HOME   ?= "$(HOME)/.cache"
XDG_RUNTIME_DIR  ?= "/run/user/$(shell id -u)"

# $HOME/.local/bin is not actually part of the XDG base dir spec
# although it is mentioned and recommended in it.
#
# Consider that putting compiled binaries in this directory is not a
# good idea as it will make your home directory architecture specific.
BIN_HOME         := "$(HOME)/.local/bin"

REGISTER_RUN_DIR := $(XDG_RUNTIME_DIR)/mk_dotfiles
export REGISTER_RUN_DIR

.SILENT: register
.PHONY: register
register: $(REGISTER_RUN_DIR)
	$(file >$(REGISTER_RUN_DIR)/uninstall.make,$(UNINSTALL_TARGET))
	echo "" >> "$(REGISTER_RUN_DIR)/uninstall.make"

	$(file >$(REGISTER_RUN_DIR)/installcheck.make,$(INSTALLCHECK_TARGET))
	echo "" >> "$(REGISTER_RUN_DIR)/installcheck.make"

	$(file >$(REGISTER_RUN_DIR)/install.make,$(INSTALL_TARGET))
	echo "" >> "$(REGISTER_RUN_DIR)/install.make"

#	./register "arg1" \	# source
#		"arg2" \	# destination
#		"arg3" \	# alias

	./register "$$(realpath config/hypr)" \
		"$(XDG_CONFIG_HOME)/hypr" \
		"hyprland"
	./register "$$(realpath config/awesome)" \
		"$(XDG_CONFIG_HOME)/awesome" \
		"awesomewm"
	./register "$$(realpath config/bspwm)" \
		"$(XDG_CONFIG_HOME)/bspwm" \
		"bspwm"
	./register "$$(realpath config/sxhkd)" \
		"$(XDG_CONFIG_HOME)/sxhkd" \
		"bspwm"
	./register "$$(realpath config/nvim)" \
		"$(XDG_CONFIG_HOME)/nvim" \
		"neovim"
	./register "$$(realpath config/waybar)" \
		"$(XDG_CONFIG_HOME)/waybar" \
		"waybar"
	./register "$$(realpath config/tmux)" \
		"$(XDG_CONFIG_HOME)/tmux" \
		"tmux"
	./register "$$(realpath config/foot)" \
		"$(XDG_CONFIG_HOME)/foot" \
		"foot"
	./register "$$(realpath config/gtklock)" \
		"$(XDG_CONFIG_HOME)/gtklock" \
		"gtklock"
	./register "$$(realpath config/dunst)" \
		"$(XDG_CONFIG_HOME)/dunst" \
		"dunst"
	./register "$$(realpath config/tofi)" \
		"$(XDG_CONFIG_HOME)/tofi" \
		"tofi"
	./register "$$(realpath config/ccache)" \
		"$(XDG_CONFIG_HOME)/ccache" \
		"ccache"
	./register "$$(realpath config/alacritty)" \
		"$(XDG_CONFIG_HOME)/alacritty" \
		"alacritty"
	./register "$$(realpath config/chromium-flags.conf)" \
		"$(XDG_CONFIG_HOME)/chromium-flags.conf" \
		"chromium"
	./register "$$(realpath config/user-dirs.dirs)" \
		"$(XDG_CONFIG_HOME)/user-dirs.dirs" \
		"xdg-dirs"
	./register "$$(realpath config/chromium-flags.conf)" \
		"$(XDG_CONFIG_HOME)/chrome-flags.conf" \
		"chrome"
	./register "$$(realpath config/fontconfig)" \
		"$(XDG_CONFIG_HOME)/fontconfig" \
		"fontconfig"
	./register "$$(realpath config/zsh)" \
		"$(XDG_CONFIG_HOME)/zsh" \
		"zsh"
	./register "$$(realpath config/X11)" \
		"$(XDG_CONFIG_HOME)/X11" \
		"xinit"
	./register "$$(realpath config/git/config)" \
		"$(XDG_CONFIG_HOME)/git/config" \
		"git"
	./register "$$(realpath config/git/ignore)" \
		"$(XDG_CONFIG_HOME)/git/ignore" \
		"git"
	./register "$$(realpath config/git/user/JosBritton)" \
		"$(XDG_CONFIG_HOME)/git/user/JosBritton" \
		"git"
	./register "$$(realpath config/git/user/JosBritton_allowed_signers)" \
		"$(XDG_CONFIG_HOME)/git/user/JosBritton_allowed_signers" \
		"git"
	./register "$$(realpath config/npm)" \
		"$(XDG_CONFIG_HOME)/npm" \
		"npm"
	./register "$$(realpath config/fastfetch)" \
		"$(XDG_CONFIG_HOME)/fastfetch" \
		"fastfetch"
	./register "$$(realpath config/fd)" \
		"$(XDG_CONFIG_HOME)/fd" \
		"fd"
	./register "$$(realpath config/picom)" \
		"$(XDG_CONFIG_HOME)/picom" \
		"picom"
	./register "$$(realpath config/eww)" \
		"$(XDG_CONFIG_HOME)/eww" \
		"eww"
	./register "$$(realpath config/clipcat)" \
		"$(XDG_CONFIG_HOME)/clipcat" \
		"clipcat"
	./register "$$(realpath config/stalonetrayrc)" \
		"$(XDG_CONFIG_HOME)/stalonetrayrc" \
		"stalonetray"
	./register "$$(realpath config/terraform)" \
		"$(XDG_CONFIG_HOME)/terraform" \
		"terraform"
	./register "$$(realpath config/yamllint)" \
		"$(XDG_CONFIG_HOME)/yamllint" \
		"yamllint"
	./register "$$(realpath config/bash)" \
		"$(XDG_CONFIG_HOME)/bash" \
		"bash"
	./register "$$(realpath config/pipewire)" \
		"$(XDG_CONFIG_HOME)/pipewire" \
		"pipewire"
	./register "$$(realpath config/wireplumber)" \
		"$(XDG_CONFIG_HOME)/wireplumber" \
		"pipewire"
	./register "$$(realpath config/kitty)" \
		"$(XDG_CONFIG_HOME)/kitty" \
		"kitty"
	./register "$$(realpath config/zathura)" \
		"$(XDG_CONFIG_HOME)/zathura" \
		"zathura"

	./register "$$(realpath data/zsh/functions/Completion)" \
		"$(XDG_DATA_HOME)/zsh/functions/Completion" \
		"zsh"
	./register "$$(realpath data/nvim/en.utf-8.add)" \
		"$(XDG_DATA_HOME)/nvim/en.utf-8.add" \
		"neovim"
	./register "$$(realpath data/applications/nvim.desktop)" \
		"$(XDG_DATA_HOME)/applications/nvim.desktop" \
		"neovim"
	./register "$$(realpath data/applications/Alacritty.desktop)" \
		"$(XDG_DATA_HOME)/applications/Alacritty.desktop" \
		"alacritty"

	./register "$$(realpath bin/switchproj)" \
		"$(BIN_HOME)/switchproj" \
		"tmux"
	./register "$$(realpath bin/tmuxopensesh)" \
		"$(BIN_HOME)/tmuxopensesh" \
		"tmux"
	./register "$$(realpath bin/scratchtmux)" \
		"$(BIN_HOME)/scratchtmux" \
		"tmux"
	./register "$$(realpath bin/bspfixsplits)" \
		"$(BIN_HOME)/bspfixsplits" \
		"bspwm"
	./register "$$(realpath bin/bspreceptacle)" \
		"$(BIN_HOME)/bspreceptacle" \
		"bspwm"
	./register "$$(realpath bin/quit_bspwm)" \
		"$(BIN_HOME)/quit_bspwm" \
		"bspwm"
	./register "$$(realpath bin/setaudio)" \
		"$(BIN_HOME)/setaudio" \
		"setaudio"
	./register "$$(realpath bin/xsetnvsync)" \
		"$(BIN_HOME)/xsetnvsync" \
		"xorg-nvidia"
	./register "$$(realpath bin/rfv)" \
		"$(BIN_HOME)/rfv" \
		"rfv"
	./register "$$(realpath bin/redoxauto)" \
		"$(BIN_HOME)/redoxauto" \
		"red_oxide"
	./register "$$(realpath bin/convert_hex_xterm)" \
		"$(BIN_HOME)/convert_hex_xterm" \
		"convert_hex_xterm"
	./register "$$(realpath bin/syncgs)" \
		"$(BIN_HOME)/syncgs" \
		"syncgs"
	./register "$$(realpath bin/ffprobe_pager)" \
		"$(BIN_HOME)/ffprobe_pager" \
		"ffmpeg"
	./register "$$(realpath bin/open_ffprobe)" \
		"$(BIN_HOME)/open_ffprobe" \
		"ffmpeg"
	./register "$$(realpath bin/terminate_bg)" \
		"$(BIN_HOME)/terminate_bg" \
		"terminate_bg"
	./register "$$(realpath bin/diff_pager)" \
		"$(BIN_HOME)/diff_pager" \
		"diff_pager"

	./register "$$(realpath home/.zshenv)" \
		"$(HOME)/.zshenv" \
		"zsh"
	./register "$$(realpath home/.steam/steam/steam_dev.cfg)" \
		"$(HOME)/.steam/steam/steam_dev.cfg" \
		"steam"
	./register "$$(realpath home/.ssh/config)" \
		"$(HOME)/.ssh/config" \
		"ssh"
	./register "$$(realpath home/.mozilla/firefox/installs.ini)" \
		"$(HOME)/.mozilla/firefox/installs.ini" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/profiles.ini)" \
		"$(HOME)/.mozilla/firefox/profiles.ini" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/user.js)" \
		"$(HOME)/.mozilla/firefox/j0hhqujf.default-release/user.js" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/user.js)" \
		"$(HOME)/.mozilla/firefox/k1yfl65t.alt/user.js" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/user.js)" \
		"$(HOME)/.mozilla/firefox/j4bekqo8.other/user.js" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/chrome)" \
		"$(HOME)/.mozilla/firefox/j0hhqujf.default-release/chrome" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/chrome)" \
		"$(HOME)/.mozilla/firefox/k1yfl65t.alt/chrome" \
		"firefox"
	./register "$$(realpath home/.mozilla/firefox/chrome)" \
		"$(HOME)/.mozilla/firefox/j4bekqo8.other/chrome" \
		"firefox"

	./register "$$(realpath home/.thunderbird/installs.ini)" \
		"$(HOME)/.thunderbird/installs.ini" \
		"thunderbird"
	./register "$$(realpath home/.thunderbird/profiles.ini)" \
		"$(HOME)/.thunderbird/profiles.ini" \
		"thunderbird"
	./register "$$(realpath home/.thunderbird/user.js)" \
		"$(HOME)/.thunderbird/j8jvvt8p.Default User/user.js" \
		"thunderbird"

.SILENT: $(REGISTER_RUN_DIR)
$(REGISTER_RUN_DIR):
	mkdir -p $(REGISTER_RUN_DIR)
