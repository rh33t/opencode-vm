[[ $- != *i* ]] && return

# history
HISTSIZE=50000
HISTFILESIZE=100000
HISTCONTROL=ignoreboth:erasedups
HISTTIMEFORMAT="%F %T "
shopt -s histappend cmdhist

# shell options
shopt -s checkwinsize cdspell dirspell nocaseglob autocd globstar
bind 'set completion-ignore-case on'
bind 'set show-all-if-ambiguous on'
bind '"\C-f":"tmux-sessionizer\n"'

# environment
export EDITOR=vim
export VISUAL=vim
export PAGER=less
export LESS='-R --quit-if-one-screen --no-init'
export LANG=en_US.utf8
export LC_ALL=en_US.utf8
export PYTHONDONTWRITEBYTECODE=1
export VIRTUAL_ENV_DISABLE_PROMPT=1
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

# navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias -- -='cd -'

# listing
alias ls='ls --color=auto --group-directories-first'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'
alias lt='ls -lath'
alias lS='ls -laSh'

# grep
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# safer defaults
alias cp='cp -iv'
alias mv='mv -iv'
alias rm='rm -Iv --preserve-root'
alias mkdir='mkdir -pv'
alias ln='ln -iv'

# disk / memory / process
alias df='df -hT --exclude-type=tmpfs --exclude-type=devtmpfs'
alias duf='du -sh -- * | sort -h'
alias meminfo='free -h'
alias psmem='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3 | head -10'
alias psg='ps aux | grep -v grep | grep -i'

# networking
alias ports='ss -tulpn'
alias listening='ss -tlnp'
alias myip='curl -s ifconfig.me && echo'
alias localip="ip -br addr show | grep -v '^lo'"
alias ping='ping -c 5'

# docker
alias d='docker'
alias dps='docker ps'
alias dpsa='docker ps -a'
alias di='docker images'
alias dc='docker compose'
alias dcu='docker compose up -d'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dce='docker compose exec'
alias dclean='docker system prune -af --volumes'
alias dccdi='docker rmi $(docker images -f "dangling=true" -q)'
alias dccall='docker stop $(docker ps -aq) >/dev/null && docker rm $(docker ps -aq) >/dev/null'

# python
alias p='python3'

# encoding / crypto
alias urlencode='python3 -c "import sys,urllib.parse as u; print(u.quote_plus(sys.argv[1]))"'
alias urldecode='python3 -c "import sys,urllib.parse as u; print(u.unquote_plus(sys.argv[1]))"'
alias b64='base64'
alias b64d='base64 -d'
alias rot13='tr "A-Za-z" "N-ZA-Mn-za-m"'
alias genpass='openssl rand -base64 32'
alias md5='md5sum'
alias sha1='sha1sum'
alias sha256='sha256sum'
alias xxd='xxd -g 1'

# misc
alias reload='source ~/.bashrc && echo "reloaded"'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%Y-%m-%d %H:%M:%S"'
alias today='date +"%Y-%m-%d"'
alias h='history | tail -50'
alias hg='history | grep'

# functions
tmux() {
  if [[ $# -eq 0 ]]; then
    command tmux new-session -A -s main
  else
    command tmux "$@"
  fi
}
mcd() { mkdir -p "$1" && cd "$1"; }
calc() { python3 -c "from math import *; print($*)"; }
serve() { python3 -m http.server "${1:-8000}"; }
whatshere() { ss -tulpn | grep ":${1}"; }
portscan() { nmap -sV --open -p- -T4 "$1"; }
wlog() { tail -f "$1" | grep --line-buffered --color=auto "${2:-.}"; }

sockets() {
  echo -e "Proto\tPID\tAddress\t\t\tService"
  ss -tulpn | awk 'NR>1 {print $1"\t"$7"\t"$5}' | column -t
}

extract() {
  [[ ! -f "$1" ]] && echo "'$1' is not a valid file" && return 1
  case "$1" in
  *.tar.bz2) tar xjf "$1" ;;
  *.tar.gz) tar xzf "$1" ;;
  *.tar.xz) tar xJf "$1" ;;
  *.tar.zst) tar --zstd -xf "$1" ;;
  *.tar) tar xf "$1" ;;
  *.tbz2) tar xjf "$1" ;;
  *.tgz) tar xzf "$1" ;;
  *.bz2) bunzip2 "$1" ;;
  *.gz) gunzip "$1" ;;
  *.rar) unrar x "$1" ;;
  *.zip) unzip "$1" ;;
  *.Z) uncompress "$1" ;;
  *.7z) 7z x "$1" ;;
  *.zst) zstd -d "$1" ;;
  *) echo "'$1' cannot be extracted via extract()" ;;
  esac
}

# prompt
if [[ $TERM != dumb ]]; then
    PS1='\[\e[1;32m\]\u@\h\[\e[0m\]:\[\e[1;34m\]\w\[\e[0m\]\$ '
else
    PS1='\u@\h:\w\$ '
fi

# completions
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif [ -f /etc/bash_completion ]; then
  . /etc/bash_completion
fi

# local overrides
[ -f ~/.bash_aliases ] && . ~/.bash_aliases
[ -f ~/.bash_local ] && . ~/.bash_local

# auto-attach tmux on SSH connection
# comment out the block below to disable auto-attaching on SSH login
if [[ -n $SSH_CONNECTION ]] && [[ -z $TMUX ]]; then
  tmux new-session -A -s main
fi