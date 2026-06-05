# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
  PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
  for rc in ~/.bashrc.d/*; do
    if [ -f "$rc" ]; then
      . "$rc"
    fi
  done
fi
unset rc

# Starship Prompt
eval "$(starship init bash)"

# VI Mode
set -o vi

# bash-completion
[[ $PS1 &&
  ! ${BASH_COMPLETION_VERSINFO:-} &&
  -f /usr/share/bash-completion/bash_completion ]] &&
  . /usr/share/bash-completion/bash_completion

# Zoxide
eval "$(zoxide init bash)"

# Exports
export EDITOR=vim

# Alias
alias vim=nvim
alias la='ls -lah'

# K3s
source <(kubectl completion bash)
alias k=kubectl
complete -o default -F __start_kubectl k
. <(flux completion bash)

. "$HOME/.local/share/../bin/env"
