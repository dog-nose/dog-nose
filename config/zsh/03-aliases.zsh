# Mac固有の設定
if [ "$(uname)" = "Darwin" ]; then
    # tacコマンドをalias
    alias tac="tail -r"
    # homebrewの自動アップデートを無効
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

# Tmux alias
alias Tmux='if tmux has-session -t 0 2>/dev/null; then tmux attach -t 0; else tmux new -s 0; fi'

# Editor aliases
alias cc='VISUAL="nvim" claude'
alias vim='nvim'
alias lazy-vim='NVIM_APPNAME=nvim-lazy nvim'
alias lvim='NVIM_APPNAME=nvim-lazy nvim'

# Override with EDITOR if set
if [[ -n ${EDITOR} ]]; then
    alias vim=${EDITOR}
    alias nvim=${EDITOR}
fi
