[[ $- != *i* ]] && return

HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T "
shopt -s histappend cmdhist checkwinsize cdspell dirspell nocaseglob
bind 'set completion-ignore-case on'

PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '

alias ls='ls --color=auto'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

alias ports='netstat -tulanp'
alias listening='lsof -i -P | grep LISTEN'
alias myip='curl -s ifconfig.me'

alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dc='docker-compose'

alias sus='ps aux | grep -v grep | grep -i -e VSZ -e'
alias meminfo='free -h'
alias psmem='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3 | head -10'

alias serve='python3 -m http.server'
alias urlencode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias b64='base64'
alias b64d='base64 -d'

alias genpass='openssl rand -base64 32'
alias md5='md5sum'
alias sha1='sha1sum'
alias sha256='sha256sum'

alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias duf='du -sh * | sort -h'

extract() {
  if [ -f $1 ]; then
    case $1 in
    *.tar.bz2) tar xjf $1 ;;
    *.tar.gz) tar xzf $1 ;;
    *.bz2) bunzip2 $1 ;;
    *.rar) unrar e $1 ;;
    *.gz) gunzip $1 ;;
    *.tar) tar xf $1 ;;
    *.tbz2) tar xjf $1 ;;
    *.tgz) tar xzf $1 ;;
    *.zip) unzip $1 ;;
    *.Z) uncompress $1 ;;
    *.7z) 7z x $1 ;;
    *) echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

bind '"\C-f":"tmux-sessionizer\n"'

mcd() { mkdir -p "$1" && cd "$1"; }

calc() { python3 -c "print($*)"; }

export PATH="$HOME/.local/bin:$HOME/bin:/usr/local/bin:$PATH"
export PATH="$HOME/.dotnet:$PATH"
export PATH=/home/vagrant/.opencode/bin:$PATH

export EDITOR=vim
export VISUAL=vim
export TERM=xterm-256color

if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# Auto-attach tmux on SSH
if [[ -n "$SSH_CONNECTION" ]] && [[ -z "$TMUX" ]]; then
  tmux attach-session -t main 2>/dev/null || tmux new-session -s main
fi
