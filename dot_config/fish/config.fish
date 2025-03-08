alias ls="command eza -la --icons --no-user"

alias activate=". .venv/bin/activate.fish"
alias act="activate"
alias deact="deactivate"

# :3
alias vim="command nvim"
alias vi="command nvim"
alias v="command nvim"
alias nvi="command nvim"
alias nv="command nvim"
alias n="command nvim"

function terminfo --wraps ssh --description "upload terminfo to remote host"
    infocmp -a $TERM | ssh $argv 'tic -x -o ~/.terminfo /dev/stdin'
end

starship init fish | source
zoxide init fish | source
