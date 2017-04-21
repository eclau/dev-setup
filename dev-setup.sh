#!/usr/bin/env bash
# Development environment boilerplate. Copyright (c) 2017, ericlau.me

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
    brew update && brew upgrade
fi

#------------------------------------------
# 1. Install Homebrew-Cask
#------------------------------------------

brew tap caskroom/cask

#------------------------------------------
# 2. Get casks
#------------------------------------------

casks=("caffeine" "dotnet" "mactex" "rstudio" "vagrant" "vagrant-manager" "virtualbox" "xquartz" "test")
mycasks=($(brew cask list))

echo ${casks[@]} ${mycasks[@]} | tr ' ' '\n' | sort | uniq -u

#------------------------------------------
# 1. Cleanup
#------------------------------------------

brew cask cleanup && brew cleanup && brew cask doctor && brew doctor