# Sahar .zshrc config
######################################

# Homebrew (Linux only)
[[ -f /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# p10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Completion paths (must be before compinit)
fpath=(/usr/share/zsh/site-functions $fpath)
if command -v brew &>/dev/null; then
    BREW_PREFIX=$(brew --prefix)
    fpath=($BREW_PREFIX/share/zsh/site-functions $fpath)
    source $BREW_PREFIX/share/powerlevel10k/powerlevel10k.zsh-theme
    source $BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    source $BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# Completions (after fpath is set up)
autoload -Uz compinit
compinit

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
    export NODE_EXTRA_CA_CERTS=~/system-certs.pem
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

# VI Mode + fzf
# bindkey -v
function zvm_after_init() {
  eval "$(fzf --zsh)"
}
source $(brew --prefix)/opt/zsh-vi-mode/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
################################

################################
# Alias
alias vim=nvim
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'

setopt GLOB_DOTS
export PATH="$HOME/.local/bin:$PATH"

. "$HOME/.local/share/../bin/env"
