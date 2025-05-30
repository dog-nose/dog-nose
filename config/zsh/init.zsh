# oh-my-zshの初期化
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="bira"
plugins=(git zsh-completions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

## ZSH_THEME="bira"のプロンプト調整
##  biraテーマが読み込まれた後でないと設定が戻ってしまうため、
##  source $ZSH/oh-my-zsh.shの後に設定すること
local date="%{$reset_color%}%D{%Y/%m/%d} %* "
local user="%B%(!.%{$fg[red]%}.%{$fg[green]%})%n%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
PROMPT="╭─${conda_prompt}${date}${user}${current_dir}${rvm_ruby}${vcs_branch}${venv_prompt}${kube_prompt}
╰─%B${user_symbol}%b "

# Mac固有の設定
if [ "$(uname)" = "Darwin" ]; then
    # tacコマンドをalias
    alias tac="tail -r"
    # homebrewの自動アップデートを無効
    export HOMEBREW_NO_AUTO_UPDATE=1
fi


GHQ_ROOT=`ghq root | sed -e "s:^$HOME:~:"`

export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'



HISTFILE=${HOME}/.config/zsh/history
HISTSIZE=100000
SAVEHIST=1000000
setopt hist_ignore_all_dups
setopt hist_ignore_dups
setopt inc_append_history
setopt share_history
setopt EXTENDED_HISTORY
setopt hist_ignore_space


zle -N my-source-file-selection
zle -N my-history-selection
bindkey '^r' history-incremental-search-backward
bindkey '^]' my-source-file-selection
bindkey '^R' my-history-selection

function my-history-selection() {
    BUFFER=`history -n 1 | tac  | awk '!a[$0]++' | fzf --no-sort --color 'border:#A3BE8C'`
    CURSOR=$#BUFFER
    zle reset-prompt
}

function my-source-file-selection () {
    local selected_dir=$(ghq list -p | fzf --color 'border:#D08770')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
