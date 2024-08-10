export FZF_DEFAULT_OPTS="--bind='ctrl-h:backward-kill-word'"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l --follow"
export EDITOR=nvim
export PATH="$PATH:$HOME/.local/bin"
[ -z $GOPATH ] || export PATH="$PATH:$GOPATH/bin"
# export PATH="$HOME/.local/lib/python3.11/site-packages:$PATH"
# export PATH="$HOME/.local/share/npm/bin:$PATH"

export XCURSOR_SIZE=24
export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"
export LIBVA_DRIVER_NAME="nvidia"
export MOZ_DRM_DEVICE="card0"

gsettings set org.gnome.desktop.interface color-scheme prefer-dark

alias nvidia-settings="nvidia-settings --config="${XDG_CONFIG_HOME:-$HOME/.config}/nvidia/settings""
alias yarn='yarn --use-yarnrc "${XDG_CONFIG_HOME:-$HOME/.config}/yarn/config"'
