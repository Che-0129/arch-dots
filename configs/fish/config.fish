alias dl='cd ~/Downloads'
alias rb='systemctl reboot'
alias sd='systemctl poweroff'
alias rm='trash-put'
alias ls='eza --icons'
alias la='eza --icons -a'
alias ll='eza --icons -l'
alias less='bat --theme Nord -p'
alias cat='bat --theme Nord -pp'
alias c='clear'
alias cls='clear && ls'
alias gc='git clone'
alias aria2='aria2c -x16 -s16'
alias untar='tar -xvf'

function sudo
    if test "$argv[1]" = "rm"
        command sudo trash-put $argv[2..-1]
    else
        command sudo $argv
    end
end
