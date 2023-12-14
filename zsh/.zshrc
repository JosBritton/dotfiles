fbrowse() {
	(&>/dev/null nautilus "$1" &)
}

clear-terminal() {
	zle kill-whole-line
	clear
	# clear scrollback even if terminal emulator does not want to
	printf "\033[3J" 
	zle .reset-prompt
	zle -R
}
zle -N clear-terminal

stty stop undef	# disable ctrl-s to freeze terminal
setopt histignorealldups sharehistory interactive_comments

HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/history"

eval "$(/usr/bin/dircolors -b)"

alias ls="LC_ALL=C ls -hN --color=auto --group-directories-first" \
	ll="LC_ALL=C ls -hN --color=auto --group-directories-first -alF" \
	la="LC_ALL=C ls -hN --color=auto --group-directories-first -A" \
	l="LC_ALL=C ls -hN --color=auto --group-directories-first -CF" \
	grep="grep --color=auto" \
	fgrep="fgrep --color=auto" \
	egrep="egrep --color=auto" \
	diff="diff --color=auto"

alias t="foot" \
	f="fbrowse" \
	nv="nvim" \
	vim="nvim" \
	vi="nvim"

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) # include dotfiles

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char

bindkey -s ^f "switchproj\n"

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H" backward-kill-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

bindkey "^L" clear-terminal

# window title
precmd() {
	echo -ne "\033]0;${USER}@${HOST}: ${PWD}\007"
}

# get 2 different randomized 8-bit ANSI colors from range for prompt
min=1
max=6
clr1="$((min + RANDOM % ((max - min) + 1)))"
clr2="$((min + RANDOM % (max - min)))"
if [ "$clr2" -ge "$clr1" ]; then
	clr2="$((clr2 + 1))"
fi
export PS1="%B[%F{$clr1}%n@%M %F{$clr2}%1~%F{reset}]%#%b "

# vim: ft=sh
