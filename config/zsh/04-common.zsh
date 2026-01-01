# GHQ settings
GHQ_ROOT=$(ghq root | sed -e "s:^$HOME:~:")
# Resolve GHQ_ROOT to its absolute path
my_ghq_root=$(eval echo "$GHQ_ROOT")

# Prompt customization (bira theme)
# This must be set after oh-my-zsh.sh is sourced
local date="%{$reset_color%}%D{%Y/%m/%d} %* "
local user="%B%(!.%{$fg[red]%}.%{$fg[green]%}) %n%{$reset_color%} "
local current_dir=$'%{$fg[blue]%}`_get_prompt_pwd`%{$reset_color%} '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
PROMPT="╭─${conda_prompt}${date}${user}${current_dir}${rvm_ruby}${vcs_branch}${venv_prompt}${kube_prompt}
╰─%B${user_symbol}%b "

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
