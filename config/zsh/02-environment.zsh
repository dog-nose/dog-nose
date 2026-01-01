# GHQ settings
GHQ_ROOT=$(ghq root | sed -e "s:^$HOME:~:")
# Resolve GHQ_ROOT to its absolute path
my_ghq_root=$(eval echo "$GHQ_ROOT")

# FZF settings
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'

# History settings
HISTFILE=${HOME}/.config/zsh/history
HISTSIZE=100000
SAVEHIST=1000000
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt inc_append_history
setopt share_history
setopt EXTENDED_HISTORY
setopt hist_ignore_space
