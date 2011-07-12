HISTFILE=~/.histfile
HISTSIZE=5000
SAVEHIST=500000
setopt appendhistory nomatch
unsetopt autocd beep extendedglob notify
bindkey -e
zstyle :compinstall filename '/etc/zsh/zshrc'

autoload -Uz compinit
autoload -U zkbd
autoload -U colors && colors
compinit

# bash style don't cycle completions if ambigious
setopt no_auto_menu

alias ls="ls --color -F"
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

PROMPT='
[%*] <%n@%m:%~>
[%#:%?] -> '
[[ $TERM == 'rxvt-unicode-256color' ]] && export TERM="rxvt-unicode"

bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word

function preexec() {
  RC="$?"
  [ $RC -ne 0 ] && RC="${fg[red]}$RC${reset_color}"
  local a=${1[(w)1]} # get the command (argv[0])
  local b=${a##*\/}  # get the command basename
  a="${b}${1#$a}"    # add back the parameters
  a=${(V)a//\%/\%\%} # remove print escapes
  a=$(print -Pn "$a" | tr -d "\n") # truncate

  case "$TERM" in
    screen|screen.rxvt)
      print -Pn "\ek%n@%m:%-3~ $a\e\\" # set screen title
      print -Pn "\e]2;%n@%m:%-3~ $a\a" # set xterm title
      ;;
    rxvt|rxvt-unicode|xterm|xterm-color)
      print -Pn "\e]2;%n@%m:%-3~ $a\a"
      ;;
  esac
}

function precmd() {
  case "$TERM" in
    screen|screen.rxvt)
      print -Pn "\ek%n@%m:%-3~\e\\" # set screen title
      print -Pn "\e]2;%n@%m:%-3~\a" # must (re)set xterm title
      ;;
  esac
}

export TZ="Europe/Stockholm"
export EDITOR="emacsclient -nw"

command -v fortune &>/dev/null && {
	echo;fortune -s;echo
}
