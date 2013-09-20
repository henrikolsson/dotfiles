if [[ -n "$PS1" ]]
then
    HISTCONTROL=ignoredups:ignorespace
    shopt -s histappend
    export HISTFILESIZE=500000
    export HISTSIZE=5000
    shopt -s checkwinsize
    [ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
    if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
        debian_chroot=$(cat /etc/debian_chroot)
    fi
    
    export PS1='\n[\t] <\u@\H:\w>\n[\\$:$?] -> '
    case "$TERM" in
        xterm*|rxvt*)
            export PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
            ;;
        Apple_Terminal)
            export PS1="\[\033]0;\u@\h:\w \007\]$PS1"
            ;;
        eterm-color)
            function eterm-set-cwd {
                $@
                echo -e "\033AnSiTc" $(pwd)
            }
            
            function eterm-reset {
                echo -e "\033AnSiTu" $(whoami)
                echo -e "\033AnSiTc" $(pwd)
                echo -e "\033AnSiTh" $(hostname)
            }
            
            for temp in cd pushd popd; do
                alias $temp="eterm-set-cwd $temp"
            done
            
            eterm-reset
            ;;
        dumb)
            export PROMPT_COMMAND=""
            export PS1="$ "
            ;;
        *)
            ;;
    esac

    [[ ( -x /usr/bin/dircolors ) || ( -x /bin/dircolors ) ]] && {
        test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
        alias ls='ls --color=auto'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
    }

    alias ll='ls -alF'
    alias la='ls -A'
    alias l='ls -CF'

    if [ -f /etc/bash_completion ] && ! shopt -oq posix; then
        . /etc/bash_completion
    fi

    for temp in wine jdk1.7 jdk1.6 android-sdk android-sdk-mac_86 maven3 maven2; do
        [ -e /opt/$temp ] && export PATH=/opt/$temp/bin:$PATH
        [ -e $HOME/opt/$temp ] && export PATH=$HOME/opt/$temp/bin:$PATH
    done
    [ -e /opt/jdk1.7 ] && export JAVA_HOME=/opt/jdk1.7
    [ -e $HOME/opt/jdk1.7 ] && export JAVA_HOME=$HOME/opt/jdk1.7 
    [ -e /opt/jdk1.6 ] && export JAVA_HOME=/opt/jdk1.6
    [ -e $HOME/opt/jdk1.6 ] && export JAVA_HOME=$HOME/opt/jdk1.6
    [ -e /opt/android-sdk ] && export ANDROID_HOME=/opt/android-sdk
    [ -e $HOME/opt/android-sdk ] && export ANDROID_HOME=$HOME/opt/android-sdk
    [ -e /opt/android-sdk-mac_86 ] && export ANDROID_HOME=/opt/android-sdk-mac_86
    [ -e $HOME/opt/android-sdk-mac_86 ] && export ANDROID_HOME=$HOME/opt/android-sdk-mac_86

    export CVSROOT=:ext:cvs:/usr/local/lib/cvs
    export CVS_RSH=ssh
    export CVSEDITOR='emacsclient -nw'
    export PATH="$HOME/bin/:$PATH"
    
    alias nohist='export HISTFILE=/dev/null'
    alias emacs-stop="emacsclient -e '(kill-emacs)'"
    alias iso-date="date '+%Y-%m-%d'"
    alias cal='cal -m'
    alias tmux='tmux -u'
    alias screen="screen -e '^Bb'"

    [ -f /usr/bin/ack-grep ] && alias ack='/usr/bin/ack-grep'

    [ `uname` == "Darwin" ] && {
        alias ls='ls -G'
        alias grep='grep --color=auto'
        alias fgrep='fgrep --color=auto'
        alias egrep='egrep --color=auto'
        alias eject='hdiutil eject'
        alias cpwd='pwd|xargs echo -n|pbcopy'
        alias apinfo='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/A/Resources/airport -I'
        spotlightfile() {
            mdfind "kMDItemDisplayName == '$@'wc";
        }
        spotlightcontent() {
            mdfind -interpret "$@";
        }
    }
    export TZ="Europe/Stockholm"
    export WINEARCH=win32
    export GTK2_RC_FILES="/etc/gtk-2.0/gtkrc:$HOME/.gtkrc-2.0"
    export PATH=/usr/share/java/apache-ant/bin/:/opt/android-sdk/tools/:$PATH
    if [ -f "${HOME}/.gnupg/gpg-agent.info" ]; then
       . "${HOME}/.gnupg/gpg-agent.info"
       export GPG_AGENT_INFO
       export SSH_AUTH_SOCK
    fi
    for i in /etc/profile.d/*.sh ; do
       if [ -r "$i" ]; then
       if [ "${-#*i}" != "$-" ]; then 
           . "$i"
       else
           . "$i" >/dev/null 2>&1
       fi
    fi
done

fi
[[ -s $HOME/.rvm/scripts/rvm ]] && source $HOME/.rvm/scripts/rvm

