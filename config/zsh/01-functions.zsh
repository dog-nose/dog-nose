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
}

# fzf history selection
function my-history-selection() {
    BUFFER=$(history -n 1 | tac | awk '!a[$0]++' | fzf --no-sort --color 'border:#A3BE8C')
    CURSOR=$#BUFFER
    zle reset-prompt
}

# fzf ghq repository selection
function my-source-file-selection() {
    local selected_dir=$(ghq list -p | fzf --color 'border:#D08770')
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}

# SSH host selection with fzf
function remote-list() {
    ssh_host=$(grep -iEh "^Host[[:space:]]" ~/.ssh/config | sed -e 's/Host[[:space:]]\(.*\)/\1/i' | tr ' ' '\n' | grep -v -e '[*?]' -e '^[[:space:]]*$' | fzf --prompt="Host\\> " --query="${*}" --select-1 | xargs -n 1)
    if [ ! -z "$ssh_host" ]; then
        echo "Connect " "$ssh_host"
        ssh "$ssh_host"
    fi
}

# Register zle widgets
zle -N my-source-file-selection
zle -N my-history-selection

# Key bindings
bindkey '^r' history-incremental-search-backward
bindkey '^]' my-source-file-selection
bindkey '^R' my-history-selection
