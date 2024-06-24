function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne "\e[1 q";;      # block
        viins|main) echo -ne "\e[5 q";; # beam
    esac
}
zle -N zle-keymap-select

zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init

_cursor_preexec_hook() {
	echo -ne "\e[5 q"
}

# vi mode
bindkey -v
export KEYTIMEOUT=1

[[ -z $preexec_functions ]] && preexec_functions=()
preexec_functions=($preexec_functions _cursor_preexec_hook)

echo -ne "\e[5 q" # Use beam shape cursor on startup.
