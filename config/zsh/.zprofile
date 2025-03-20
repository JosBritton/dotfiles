export FZF_DEFAULT_OPTS="--bind='ctrl-h:backward-kill-word'"
export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l --follow"
export EDITOR=nvim
export PATH="$PATH:$HOME/.local/bin"
[ -z $GOPATH ] || export PATH="$PATH:$GOPATH/bin"
[ -z $CARGO_HOME ] || export PATH="$PATH:$CARGO_HOME/bin"

export XCURSOR_SIZE=24
export LESS='-R --use-color -Dd+r$Du+b$'
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export MANROFFOPT="-P -c"
export LIBVA_DRIVER_NAME="nvidia"
export MOZ_DISABLE_RDD_SANDBOX=1
export __EGL_VENDOR_LIBRARY_FILENAMES="/usr/share/glvnd/egl_vendor.d/10_nvidia.json"
export MOZ_DRM_DEVICE="card0"

export __GL_SHADER_DISK_CACHE=1
export __GL_SHADER_DISK_CACHE_SKIP_CLEANUP=1
export __GL_SHADER_DISK_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nv"

gsettings set org.gnome.desktop.interface color-scheme prefer-dark

