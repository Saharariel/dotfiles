# Sahar .zshrc config
######################################

# Homebrew (Linux only)
[[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# p10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Completions (must be before kubectl/flux)
autoload -Uz compinit
compinit

if command -v brew &>/dev/null; then
    # Brew Paths
    BREW_PREFIX=$(brew --prefix)
    source $BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme
    source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
######################################

######################################
# Work Laptop
if [[ $(hostname) == "LAP221-2.local" ]]; then
   # toka-scripts
    export PATH="$HOME/Scripts/path_scripts:$PATH"
    alias sc="cd $HOME/Scripts/path_scripts"
    alias pdu="$HOME/Scripts/python/pdu"
    ssh-add ~/.ssh/ssh.key
    # Docker CLI completions
    fpath=(/Users/lap221/.docker/completions $fpath)
    # vvr-clusters
    export KUBECONFIG=$HOME/.kube/config:$HOME/.kube/vps-cluster
fi
######################################

######################################
# Exports
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export TERM=xterm-256color
################################

################################
# Zoxide init
eval "$(zoxide init zsh)"

# Kubernetes stuff
alias k="kubectl"
source <(kubectl completion zsh)
. <(flux completion zsh)

# fzf
eval "$(fzf --zsh)"

# VI Mode
# bindkey -v
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
################################

################################
# Alias
alias vim=nvim
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'

setopt GLOB_DOTS
