# Sahar .zshrc config

######################################
# p10k prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
######################################

######################################
# Work Laptop
if [[ $(hostname) == "LAP221" ]]; then 
   # toka-scripts
    export PATH="$HOME/Scripts/path_scripts:$PATH"
    alias sc="cd $HOME/Scripts/path_scripts"
    alias pdu="$HOME/Scripts/python/pdu"
    ssh-add ~/.ssh/ssh.key
    # The following lines have been added by Docker Desktop to enable Docker CLI completions.
    fpath=(/Users/lap221/.docker/completions $fpath)
    autoload -Uz compinit
    compinit
    # End of Docker CLI completions
######################################

######################################
# Exports

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# Terminal Type
export TERM=xterm-256color

################################

# Zoxide init
eval "$(zoxide init zsh)"
 
# Kubernates stuff
alias k="kubectl"
source <(kubectl completion zsh)
. <(flux completion zsh)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

################################
# Alias
alias vim=nvim
alias ll="ls -lah"


