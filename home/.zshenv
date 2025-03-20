export ZDOTDIR="${XDG_CONFIG_HOME:-$HOME/.config}/zsh"
export CUDA_CACHE_PATH="${XDG_CACHE_HOME:-$HOME/.cache}/nv"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"
export XINITRC="${XDG_CONFIG_HOME:-$HOME/.config}/X11/xinitrc"
export CARGO_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/cargo"
export NPM_CONFIG_USERCONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/npm/config"
export RUSTUP_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/rustup"
export PYTHON_HISTORY="${XDG_STATE_HOME:-$HOME/.local/state}/python/history"
export PYTHONPYCACHEPREFIX="${XDG_CACHE_HOME:-$HOME/.cache}/python"
export PYTHONUSERBASE="${XDG_DATA_HOME:-$HOME/.local/share}/python"
export ANSIBLE_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/ansible"
export ANSIBLE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/ansible.cfg"
export ANSIBLE_GALAXY_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/ansible/galaxy_cache"
export KUBECONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/kube" 
export KUBECACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}/kube"
export GOPATH="${XDG_DATA_HOME:-$HOME/.local/share}/go"
export GOMODCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go/mod"
export GOCACHE="${XDG_CACHE_HOME:-$HOME/.cache}/go-build"
export TF_CLI_CONFIG_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/terraform/cli.tfrc"
export WINEPREFIX="${XDG_DATA_HOME:-$HOME/.local/share}/wine"
export GTK_THEME="Adwaita:dark"
export PARALLEL_HOME="${XDG_CONFIG_HOME:-$HOME/.config}/parallel"
export _JAVA_OPTIONS=-Djava.util.prefs.userRoot="${XDG_CONFIG_HOME:-$HOME/.config}"/java
export DOCKER_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}"/docker

# xdg base dirs
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
