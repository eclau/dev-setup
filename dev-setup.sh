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
git config --global http.proxy "${httpproxy}"
git config --global https.proxy "${httpsproxy}"

#------------------------------------------
# 1. Install Command Line Tools
#------------------------------------------

if type xcode-select >&- && xpath=$(xcode-select --print-path)

#------------------------------------------
# 2. Install Homebrew
#------------------------------------------

which -s brew
if [[ $? != 0 ]] ; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    brew update && brew upgrade
fi

#------------------------------------------
# 1. Get taps
#------------------------------------------

targets=("caskroom/cask" "caskroom/fonts" "homebrew/science")
mytaps=($(brew tap))
diff=(`echo ${targets[@]} ${mytaps[@]} | tr ' ' '\n' | sort | uniq -u`)

for tap in $diff ; do
    brew tap $tap
done

#------------------------------------------
# 2. Get casks
#------------------------------------------

targets=("caffeine" "dotnet" "mactex" "postman" "rstudio" "vagrant" "vagrant-manager" "visual-studio" "visual-studio-code" "virtualbox" "xquartz")
mycasks=($(brew cask list))
diff=(`echo ${targets[@]} ${mycasks[@]} | tr ' ' '\n' | sort | uniq -u`)

for cask in $diff ; do
    brew cask install $cask
done

#------------------------------------------
# 2. Install formula
#------------------------------------------



#------------------------------------------
# 4. Cleanup
#------------------------------------------

#brew cask cleanup && brew cleanup && brew cask doctor && brew doctor