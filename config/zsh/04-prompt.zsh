# Prompt customization (bira theme)
# This must be set after oh-my-zsh.sh is sourced

# Prompt variables
_prompt_date="%{$reset_color%}%D{%Y/%m/%d} %* "
_prompt_user="%B%(!.%{$fg[red]%}.%{$fg[green]%}) %n%{$reset_color%} "
_prompt_current_dir=$'%{$fg[blue]%}`_get_prompt_pwd`%{$reset_color%} '

# Git prompt theme
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"

# Set PROMPT
PROMPT="╭─${conda_prompt}${_prompt_date}${_prompt_user}${_prompt_current_dir}${rvm_ruby}${vcs_branch}${venv_prompt}${kube_prompt}
╰─%B${user_symbol}%b "
