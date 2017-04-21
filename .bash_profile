# Bash profile. Copyright (c) 2017, ericlau.me

#------------------------------------------
# 0. Source Defaults
#------------------------------------------

# load .bashrc if it exists
test -f ~/.bashrc && source ~/.bashrc
 
#------------------------------------------
# 1. Env Configuration
#------------------------------------------

# make sure homebrew dir is at the top
export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# export proxy settings if enabled
# credtit: https://dmorgan.info/posts/mac-network-proxy-terminal/
httpproxy=`scutil --proxy | awk '\
/HTTPEnable/ { enabled = $3; } \
/HTTPProxy/ { server = $3; } \
/HTTPPort/ { port = $3; } \
END { if (enabled == "1") { print "http://" server ":" port; } }'`
httpsproxy=`scutil --proxy | awk '\
/HTTPSEnable/ { enabled = $3; } \
/HTTPSProxy/ { server = $3; } \
/HTTPSPort/ { port = $3; } \
END { if (enabled == "1") { print "http://" server ":" port; } }'`
export http_proxy="${httpproxy}"
export https_proxy="${httpsproxy}"

#------------------------------------------
# 2. Symbolic Links
#------------------------------------------

#------------------------------------------
# 3. Alias
#------------------------------------------

alias ~='cd ~'
alias bu='brew update && brew upgrade && brew cask cleanup && brew cleanup && brew cask doctor && brew doctor'
alias bs='brew search'
alias bcs='brew cask search'
alias c='clear'
alias cd..='cd ../'
alias .1='cd ../'
alias .2='cd ../../'
alias .3='cd ../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../../'
alias .6='cd ../../../../../../'
alias cp='cp -iv'
alias du='diskutil info /'
alias edit='code --force-gpu-rasterization'
alias f='open -a Finder ./'
alias fix_stty='stty sane'
alias ll='ls -FGlAhp'
alias mkdir='mkdir -pv'
alias mv='mv -iv'
alias p='ping -o'
alias path="echo $PATH | tr ':' '\n' | sort | uniq -u"
alias pathhelp='eval $(/usr/libexec/path_helper -s)'
alias rm='rm -i'
alias show_options='shopt'
alias unhide='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias hide='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias whichall='type -all'
# create a new dir and cd inside
mcd() { mkdir -p $1 && cd $1 ; }
# move to trash
trash() { command mv $@ ~/.Trash ; }

#------------------------------------------
# 4. File Management
#------------------------------------------

# create a zip archive for a folder
zipf() { zip -r $1.zip $1; }
extract() {
    if [ -f $1 ] ; then
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

#------------------------------------------
# 5. Searching
#------------------------------------------

# quickly search for file
alias qfind="find . -name"
# find file under the current dir
ff() { /usr/bin/find . -name '*'"$@"'*' ; }
# find file that starts with a given string
spotlight() { mdfind "$@" -onlyin . ; }

#------------------------------------------
# 6. Process Management
#------------------------------------------

# find out the pid of a specified process, findpid '/d$/'
findpid () { lsof -t -c "$@"; }
# find memory hogs
alias memhogstop='top -l 1 -o rsize | head -20'
alias memhogsps='ps wwaxm -o pid,stat,vsize,rss,time,command | head -10'

#------------------------------------------
# 7. Network Managament
#------------------------------------------

# public facing ip
alias myip='curl -w "\n" ip.appspot.com'
alias h="hostname"
alias dns="cat /etc/resolv.conf"