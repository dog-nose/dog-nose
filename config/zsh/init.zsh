# oh-my-zshの初期化
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="bira"
plugins=(git zsh-completions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

GHQ_ROOT=$(ghq root | sed -e "s:^$HOME:~:")

# Resolve GHQ_ROOT to its absolute path
my_ghq_root=$(eval echo "$GHQ_ROOT")

# Function to get the current directory, with ghq root adjusted
function _get_prompt_pwd() {
    local current=$(pwd | sed -e "s:^$HOME:~:")
    local github_root="${GHQ_ROOT}/github.com"
    if [[ "$current" =~ ^$github_root ]]; then
        echo $current | perl -pe "s:^$github_root.*?\/: :"
        return
    fi
    if [[ "$current" =~ ^$GHQ_ROOT ]]; then
        echo $current | perl -pe "s:^$GHQ_ROOT\/:󰊢 :"
        return
    fi
    echo $current | sed -e "s:^~::"
    # if [ "$current" = "~" ]; then
    #     echo $current
    #     return
    # fi

    # local dirname=`dirname $current | sed -e "s:\(\/.\)[^\/]*:\1:g"`
    # local basename=`basename $current`
    # echo "$dirname/$basename"
}

## ZSH_THEME="bira"のプロンプト調整
##  biraテーマが読み込まれた後でないと設定が戻ってしまうため、
##  source $ZSH/oh-my-zsh.shの後に設定すること
local date="%{$reset_color%}%D{%Y/%m/%d} %* "
local user="%B%(!.%{$fg[red]%}.%{$fg[green]%}) %n%{$reset_color%} "
local current_dir=$'%{$fg[blue]%}`_get_prompt_pwd`%{$reset_color%} '
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[green]%}"
# local user_symbol='%(!.#.)'
#╭─2025/07/15 11:40:01  yamawaki ~/Repositories/src/github.com.private/dog-nose/dog-nose/config/zsh fix_other_pc
#╰─$
#
#  owner/repo
#   owner/repo
# 󰊢 github.com/
PROMPT="╭─${conda_prompt}${date}${user}${current_dir}${rvm_ruby}${vcs_branch}${venv_prompt}${kube_prompt}
╰─%B${user_symbol}%b "

# Mac固有の設定
if [ "$(uname)" = "Darwin" ]; then
    # tacコマンドをalias
    alias tac="tail -r"
    # homebrewの自動アップデートを無効
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

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
    BUFFER=$(history -n 1 | tac | awk '!a[$0]++' | fzf --no-sort --color 'border:#A3BE8C')
    CURSOR=$#BUFFER
    zle reset-prompt
}

function my-source-file-selection() {
    local selected_dir=$(ghq list -p | fzf --color 'border:#D08770')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

alias Tmux='if tmux has-session -t 0 2>/dev/null; then tmux attach -t 0; else tmux new -s 0; fi'

function remote-list() {
    ssh_host=$(grep -iEh "^Host[[:space:]]" ~/.ssh/config | sed -e 's/Host[[:space:]]\(.*\)/\1/i' | tr ' ' '\n' | grep -v -e '[*?]' -e '^[[:space:]]*$' | fzf --prompt="Host\\> " --query="${*}" --select-1 | xargs -n 1)
    if [ ! -z "$ssh_host" ]; then
        echo "Connect " "$ssh_host"
        ssh "$ssh_host"
    fi
}

alias cc='VISUAL="nvim" claude'
alias vim='nvim'
alias lazy-vim='NVIM_APPNAME=nvim-lazy nvim'
alias lvim='NVIM_APPNAME=nvim-lazy nvim'
if [[ -n ${EDITOR} ]]; then
    alias vim=${EDITOR}
    alias nvim=${EDITOR}
fi
