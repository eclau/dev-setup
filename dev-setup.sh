#!/bin/bash

#------------------------------------------
# 0. Setup terminal proxy
#------------------------------------------

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
# 1. Install Homebrew
#------------------------------------------

which -s brew
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update && brew upgrade && brew doctor
fi

#------------------------------------------
# 1. Install Homebrew-Cask
#------------------------------------------

brew tap caskroom/cask