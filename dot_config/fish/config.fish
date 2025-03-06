alias ls="command eza -la --icons --no-user"

alias activate=". .venv/bin/activate.fish"
alias act="activate"
alias deact="deactivate"

alias ssh="TERM=xterm-256color command ssh"

# :3
alias vim="command nvim"
alias vi="command nvim"
alias v="command nvim"
alias nvi="command nvim"
alias nv="command nvim"
alias n="command nvim"

starship init fish | source
zoxide init fish | source
