[[ -o "interactive" ]] || return

[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/zsh" ] || mkdir -p "${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[ ! -e "${XDG_STATE_HOME:-$HOME/.local/state}/zsh" ] || mkdir -p "${XDG_STATE_HOME:-$HOME/.local/state}/zsh"
[ ! -e "$HOME/.local/share/zsh/functions/Completion" ] || mkdir -p "$HOME/.local/share/zsh/functions/Completion"

[[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-key-bindings.zsh" ]] \
    && ln -sf /usr/share/fzf/key-bindings.zsh \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-key-bindings.zsh"

[[ "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-key-bindings.zsh.zwc" \
    -nt /usr/share/fzf/key-bindings.zsh ]] \
    || zcompile -R -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-key-bindings.zsh.zwc" \
    /usr/share/fzf/key-bindings.zsh

[[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-completion.zsh" ]] \
    && ln -sf /usr/share/fzf/completion.zsh \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-completion.zsh"

[[ "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-completion.zsh.zwc" \
    -nt /usr/share/fzf/completion.zsh ]] \
    || zcompile -R -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-completion.zsh.zwc" \
    /usr/share/fzf/completion.zsh

[[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/you-should-use.plugin.zsh" ]] \
    && ln -sf /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/you-should-use.plugin.zsh"

[[ "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/you-should-use.plugin.zsh.zwc" \
    -nt /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh ]] \
    || zcompile -R -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/you-should-use.plugin.zsh.zwc" \
    /usr/share/zsh/plugins/zsh-you-should-use/you-should-use.plugin.zsh

[[ ! -e "${ZDOTDIR:-$HOME}/vi.zsh" || "${ZDOTDIR:-$HOME}/vi.zsh.zwc" -nt "${ZDOTDIR:-$HOME}/vi.zsh" ]] \
    || zcompile -R -- "${ZDOTDIR:-$HOME}/vi.zsh.zwc" "${ZDOTDIR:-$HOME}/vi.zsh"
source "${ZDOTDIR:-$HOME}/vi.zsh"

# [[ ! -e "${ZDOTDIR:-$HOME}/tmux.zsh" || "${ZDOTDIR:-$HOME}/tmux.zsh.zwc" -nt "${ZDOTDIR:-$HOME}/tmux.zsh" ]] \
#     || zcompile -R -- "${ZDOTDIR:-$HOME}/tmux.zsh.zwc" "${ZDOTDIR:-$HOME}/tmux.zsh"
# source "${ZDOTDIR:-$HOME}/tmux.zsh"

stty stop undef	 # disable ctrl-s to freeze terminal

source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/you-should-use.plugin.zsh"
source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-key-bindings.zsh"
source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-completion.zsh"

zstyle ":completion:*" use-cache on
zstyle ":completion:*" cache-path "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompcache"
zstyle ":completion:*" matcher-list "m:{a-z}={A-Z}"  # complete match any-case on lowercase only
zstyle ':completion:*' verbose true
zstyle ":completion:*" list-colors "${(s.:.)LS_COLORS}"
zstyle ":completion:*" menu select=5  # only show menu for more than 5 options

# start menu completion only if it could find no unambiguous initial string
zstyle ':completion:*:correct:*'       insert-unambiguous true
zstyle ':completion:*:corrections'     format $'%{\e[0;31m%}%d (errors: %e)%{\e[0m%}'
zstyle ':completion:*:correct:*'       original true

# bash-style word functions
autoload -U select-word-style
select-word-style bash

# use fd for fzf path completion (place after plugin is loaded)
_fzf_compgen_path() { fd --hidden --follow --exclude ".git" . "$1"; }
_fzf_compgen_dir() { fd --type d --hidden --follow --exclude ".git" . "$1"; }

# user completion directory
fpath=("$HOME/.local/share/zsh/functions/Completion" $fpath)

# load menu completion module *before* completion system
zmodload zsh/complist
# init completion system and dump to cache file
autoload -Uz compinit
compinit -d "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
# compile completion cache to word-code if updated
[[ "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION.zwc" \
    -nt "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION" ]] \
    || zcompile -R -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION.zwc" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"

_comp_options+=(globdots)  # include dotfiles in glob for completion only

restore_stdio() {
    # fixes tmux: not a terminal error
    exec </dev/tty
    exec <&1
}

clear_terminal_all() {
    zle kill-whole-line
    echoti clear 2>/dev/null
    print -n -- "\e[H\e[2J\e[3J"
    zle .reset-prompt
    zle -R
}

open_tmux_scratch_prompt() {
    scratchtmux
    zle reset-prompt
}

open_neovim_cwd() {
    [ -f "./.venv/bin/activate" ] && . ./.venv/bin/activate
    [ -f "./.env/bin/activate" ] && . ./.env/bin/activate
    nvim .
    zle redisplay
}

open_project_session() {
    restore_stdio
    switchproj
    zle reset-prompt
}

tmux_switch_session() {
    restore_stdio
    tmuxopensesh
    zle reset-prompt
}

HISTDUP=erase
HISTSIZE=10000000
SAVEHIST=10000000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"

local opts=(
    histignorealldups
    sharehistory
    interactivecomments
    appendhistory
    histsavenodups
    histignoredups
    histfindnodups
    glob_dots
)
setopt $opts

# generate LS_COLORS
[[ ! -e "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh" ]] \
    && dircolors -p | perl -pe 's/^((CAP|S[ET]|O[TR]|M|E)\w+).*/$1 00/' | dircolors - > \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh"
[[ "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zwc" \
    -nt "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh" ]] \
    || zcompile -R -- "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zwc" \
    "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh"
source "${XDG_CACHE_HOME:-$HOME/.cache}/zsh/dircolors.zsh"

alias fetch="fastfetch" \
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
    ll="LC_ALL=C ls -hN1F --color=auto --group-directories-first -al" \
    la="LC_ALL=C ls -hN1F --color=auto --group-directories-first -A" \
    l="LC_ALL=C ls -hN1F --color=auto --group-directories-first" \
    gs="git status" \
    t="bgnull alacritty" \
    f="bgnull thunar" \
    gb="gh browse" \
    nvclean="nvim -c \"set clipboard=unnamedplus\" --clean -n --noplugin" \
    gcp="git cherry-pick --signoff"

# overrides
alias ls="LC_ALL=C ls -hN1F --color=auto --group-directories-first" \
    journalctl="journalctl --all --full --reverse" \
    grep="grep --color=auto" \
    fgrep="fgrep --color=auto" \
    egrep="egrep --color=auto" \
    diff="diff --color=auto" \
    ip="ip -color=auto" \
    nvidia-settings="nvidia-settings --config="${XDG_CONFIG_HOME:-$HOME/.config}/nvidia/settings"" \
    yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME:-$HOME/.config}/yarn/config"' \
    wget="wget --hsts-file="${XDG_CACHE_HOME:-$HOME/.cache}/wget-hsts""

zle -N clear_terminal_all
zle -N open_tmux_scratch_prompt
zle -N open_project_session
zle -N tmux_switch_session
zle -N open_neovim_cwd

# use vi keys in tab complete menu
bindkey -M menuselect "h" vi-backward-char
bindkey -M menuselect "k" vi-up-line-or-history
bindkey -M menuselect "l" vi-forward-char
bindkey -M menuselect "j" vi-down-line-or-history

bindkey -v "^?" backward-delete-char

bindkey -M menuselect "^[[Z" reverse-menu-complete  # enable shift+tab functionality

bindkey "^f" open_project_session
bindkey "^\`" open_tmux_scratch_prompt
bindkey "^n" open_neovim_cwd
bindkey "^L" clear_terminal_all
bindkey "^j" tmux_switch_session

bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^H" backward-kill-word
bindkey "^[[H" beginning-of-line
bindkey "^[[F" end-of-line
bindkey "^[[3~" delete-char

local bold_prompt
typeset -A promptcolors
if [[ $COLORTERM = *(24bit|truecolor)* ]]; then
    # credit: sindresorhus/hyper-snazzy
    promptcolors[grey]="%F{#6c6c6c}"
    promptcolors[red]="%F{#ff5c57}"
    promptcolors[green]="%F{#5af78e}"
    promptcolors[yellow]="%F{#f3f99d}"
    promptcolors[blue]="%F{#57c7ff}"
    promptcolors[magenta]="%F{#ff6ac1}"
    promptcolors[cyan]="%F{#9aedfe}"
    promptcolors[white]="%F{#f1f1f0}"
elif [[ $TERM =~ 256color || $TERM == fbterm ]]; then
    promptcolors[grey]="%F{242}"
    promptcolors[red]="%F{203}"
    promptcolors[green]="%F{84}"
    promptcolors[yellow]="%F{229}"
    promptcolors[blue]="%F{81}"
    promptcolors[magenta]="%F{205}"
    promptcolors[cyan]="%F{123}"
    promptcolors[white]="%F{231}"
else
    promptcolors[grey]="%F{0}"
    promptcolors[red]="%F{1}"
    promptcolors[green]="%F{2}"
    promptcolors[yellow]="%F{3}"
    promptcolors[blue]="%F{4}"
    promptcolors[magenta]="%F{5}"
    promptcolors[cyan]="%F{6}"
    promptcolors[white]="%F{7}"
    bold_prompt=true
fi

local user
if [[ $UID != 1000 ]]; then
    user=%n
fi

local host
if [[ -v SSH_CLIENT ]]; then
    host=%m
fi

local promptdircolors=(
"$promptcolors[red]"
"$promptcolors[green]"
"$promptcolors[blue]"
)
local prompt_prefix="${bold_prompt:+%B}${promptdircolors[$(( $RANDOM % ${#promptdircolors[@]} + 1 ))]}%50<...<%~%<<%f${bold_prompt:+%b} "
local prompt_suffix="${bold_prompt:+%B}$promptcolors[white]${user}$promptcolors[grey]${user:+${host:+@}}${host}%#%f${bold_prompt:+%b} "

unset RPROMPT
PROMPT="$prompt_prefix$prompt_suffix"

export VIRTUAL_ENV_DISABLE_PROMPT=1

autoload -Uz vcs_info
zstyle ":vcs_info:*" enable git  # enable only the vcs module for git

# in format string ":" = separator
zstyle ":vcs_info:*" actionformats "%b:%c%u:%m:%a:"
zstyle ":vcs_info:*" formats "%b:%c%u:%m:"

zstyle ":vcs_info:*" check-for-changes true
zstyle ":vcs_info:*" get-revision true
zstyle ":vcs_info:*" stagedstr "+"
zstyle ":vcs_info:*" unstagedstr "!"

# more: https://github.com/zsh-users/zsh/blob/master/Misc/vcs_info-examples
zstyle ":vcs_info:git*+set-message:*" hooks git-untracked git-remote

+vi-git-untracked() {
    if [[ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" == "true" ]] && \
        git status --porcelain | grep "??" &> /dev/null ; then
        hook_com[staged]+="?"
    fi
}

+vi-git-remote() {
    local ahead behind
    local -a gitstatus

    # exit early in case the worktree is on a detached HEAD
    git rev-parse ${hook_com[branch]}@{upstream} >/dev/null 2>&1 || return 0

    local -a ahead_and_behind=(
        $(git rev-list --left-right --count HEAD...${hook_com[branch]}@{upstream} 2>/dev/null)
    )

    ahead=${ahead_and_behind[1]}
    behind=${ahead_and_behind[2]}

    (( $ahead )) && gitstatus+=( "+${ahead}" )
    (( $behind )) && gitstatus+=( "-${behind}" )

    hook_com[misc]+=${(j:/:)gitstatus}
}

# backgroud launcher
bgnull() {
    [ "$EUID" -eq 0 ] && return

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
compdef _path_commands bgnull  # add PATH completion

get_vcs_info() {
    vcs_info
    # `(s.:.)` split ":" in vcs formatted string (eliding empty)
    echo "${bold_prompt:+%B}$promptcolors[grey]${(s.:.)vcs_info_msg_0_}%f${bold_prompt:+%b}"
}

get_vcs_info_complete() {
    # read from fd
    local render_prompt
    render_prompt="$prompt_prefix$(<&$1)$prompt_suffix"

    # remove the handler and close the fd
    zle -F "$1"
    exec {1}<&-

    if [ "$PROMPT" = "$render_prompt" ]; then
        return
    fi

    # redraw if necessary
    PROMPT="$render_prompt"
    zle && zle reset-prompt
}

get_vcs_info_precmd() {
    typeset -g _PROMPT_ASYNC_FD

    # close last fd if existent, discarding result
    if [[ -n "$_PROMPT_ASYNC_FD" ]] && { true <&$_PROMPT_ASYNC_FD } 2>/dev/null; then
        exec {_PROMPT_ASYNC_FD}<&-
    fi

    # get vcs_info in a background process
    exec {_PROMPT_ASYNC_FD}< <(printf "%s" "$(get_vcs_info)")

    # when fd is readable, call response handler
    zle -F "$_PROMPT_ASYNC_FD" get_vcs_info_complete

    # do not clear PROMPT, let it persist
}

print_title() {
    print -Pn "\033]0;$@\007"
}

set_title_precmd() {
    print_title "zsh %~"
}

set_title_preexec() {
    print_title "${1//\%/%%}"
}

local zshcache_time="$(date +%s%N)"
pacman_rehash() {
    if [[ ! -a /var/cache/zsh/pacman ]]; then
        return
    fi

    local paccache_time="$(date -r /var/cache/zsh/pacman +%s%N)"
    if (( zshcache_time < paccache_time )); then
        rehash
        zshcache_time="$paccache_time"
    fi
}

compdef _diff diff_pager

autoload -Uz add-zsh-hook
add-zsh-hook precmd set_title_precmd
add-zsh-hook precmd get_vcs_info_precmd
add-zsh-hook precmd pacman_rehash
add-zsh-hook preexec set_title_preexec
