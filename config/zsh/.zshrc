[[ $- != *i* ]] && return

# mkdir -p "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/functions/"
# mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh/"
# mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/"

# todo:
# 1. Suggest aliases
# 2. Suggest `sudoedit` instead of `sudo nvim` whenever it is sent

bgnull() {
	# terminal "launcher"

	if [ "$EUID" -eq 0 ]; then
		echo "You are too dangerous to be left alive."
		return 1
	fi

	if [ -z "$WM_EXEC" ]; then
		(&>/dev/null "$@" &)
		return
	fi

	if [ "$XDG_CURRENT_DESKTOP" = "Hyprland" ]; then
		hyprctl dispatch exec "$@" >/dev/null
		return
	fi

	# fallback
	(&>/dev/null "$@" &)
}

_restore_stdio() {
	# fixes tmux: not a terminal error
	exec </dev/tty
	exec <&1
}

zle_clear_term() {
	zle kill-whole-line
	zle clear-screen

	printf "\33c\e[3J"
}
zle -N zle_clear_term

zle_switch_project() {
	_restore_stdio
	switchproj
    if (( $? == 0 )); then
        local precmd
        for precmd in $precmd_functions; do
            $precmd
        done
        zle reset-prompt
    fi
}
zle -N zle_switch_project

zle_scratch_tmux() {
	scratchtmux
	zle reset-prompt
}
zle -N zle_scratch_tmux

zle_open_neovim_here() {
	if [ -f "./.venv/bin/activate" ]; then . ./.venv/bin/activate; fi
	nvim .
	zle redisplay
}
zle -N zle_open_neovim_here

zle_reload_zsh() {
	_restore_stdio
	. ~/.zshrc
	echo Reloaded ~/.zshrc
	zle reset-prompt
}
zle -N zle_reload_zsh

stty stop undef	# disable ctrl-s to freeze terminal
setopt histignorealldups sharehistory interactive_comments

fpath=(~/.local/share/zsh/functions/Completion $fpath)

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
#if ! [ -f "$HISTFILE" ]; then touch "$HISTFILE"; fi

# eval "$(/usr/bin/dircolors -b)"
eval "$(dircolors -p | perl -pe 's/^((CAP|S[ET]|O[TR]|M|E)\w+).*/$1 00/' | dircolors -)"

alias nv="nvim" \
	vim="nvim" \
	vi="nvim" \
	fetch="fastfetch" \
	rsyncright="rsync --info=progress2 --no-i-r -a" \
	ta="tmux attach -t" \
	tad="tmux attach -d -t" \
	ts="tmux new-session -s" \
	tl="tmux list-sessions" \
	tksv="tmux kill-server" \
	tkss="tmux kill-session -t" \
	tmuxconf="$EDITOR ~/.config/tmux/tmux.conf" \
	pacex="pacman -Qe" \
	pacorph="pacman -Qdt" \
	pacexnoreq="pacman -Qet" \
	statoctal="stat -c '%a'" \
	ll="LC_ALL=C ls -hN --color=auto --group-directories-first -alF" \
	la="LC_ALL=C ls -hN --color=auto --group-directories-first -A" \
	l="LC_ALL=C ls -hN --color=auto --group-directories-first -CF"

# launcher
alias t="bgnull alacritty" \
	f="bgnull thunar" \

# overwriting
alias ls="LC_ALL=C ls -hN --color=auto --group-directories-first" \
	journalctl="journalctl --all --full --reverse" \
	grep="grep --color=auto" \
	fgrep="fgrep --color=auto" \
	egrep="egrep --color=auto" \
	diff="diff --color=auto" \
	ip="ip -color=auto"

autoload -U compinit
zstyle ':completion:*' cache-path ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache
# zstyle ':completion:*' menu select
zmodload zsh/complist
compinit -d ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION
_comp_options+=(globdots) # include dotfiles

compdef _path_commands bgnull # add PATH completion

source "/usr/share/fzf/completion.zsh"

_fzf_compgen_path() {
	fd --hidden --follow . "$1"
}

_fzf_compgen_dir() {
	fd --type d --hidden --follow . "$1"
}

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey "^f" zle_switch_project
bindkey "^\`" zle_scratch_tmux
bindkey "^n" zle_open_neovim_here
bindkey "^r" zle_reload_zsh
bindkey "^L" zle_clear_term

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H" backward-kill-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

source "/usr/share/fzf/key-bindings.zsh"

precmd() {
	echo -ne "\033]0;${USER}@${HOST}: ${PWD}\007" # window title
}

# get 2 different randomized 8-bit ANSI colors from range for prompt
local min=1
local max=6
local clr1="$((min + RANDOM % ((max - min) + 1)))"
local clr2="$((min + RANDOM % (max - min)))"
if [ "$clr2" -ge "$clr1" ]; then
	clr2="$((clr2 + 1))"
fi
export PS1="%B[%F{$clr1}%n@%M %F{$clr2}%1~%F{reset}]%#%b "

