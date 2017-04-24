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
# set terminal proxy
export http_proxy="${httpproxy}"
export https_proxy="${httpsproxy}"
# set git proxy
git config --global http.proxy "${httpproxy}"
git config --global https.proxy "${httpsproxy}"

#------------------------------------------
# 1. Install Command Line Tools
#------------------------------------------

if type xcode-select >&- && \
    xpath=$(xcode-select --print-path) && \
    test -d "${xpath}" && \
    test -x "${xpath}" ; then
    echo "Detected xcode-select, nothing to do here..."
else
    xcode-select --install
fi

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

taps=()
taps+=("caskroom/cask" "caskroom/fonts" "homebrew/science")
# current
mytaps=($(brew tap))
diff=(`echo ${taps[@]} ${mytaps[@]} | tr ' ' '\n' | sort | uniq -u`)

for tap in $diff ; do
    echo "Tapping: " $tap
    brew tap $tap
done

#------------------------------------------
# 2. Install packages
#------------------------------------------

packages=()
# container
packages+=("docker" "docker-compose" "docker-machine")
# data science
packages+=("boost" "libsvg" "libxml2" "gdal" "geos" "r")
# db
packages+=("mongodb" "mysql")
# dev
packages+=("kotlin" "node" "python" "python3")
# iaas
packages+=("awscli")
# repo
packages+=("git")
# security
packages+=("gnupg" "openssl")
# misc
packages+=("bash-completion" "brew-cask-completion" "curl" "p7zip")

for package in $packages ; do
    which -s $package
    if [[ $? -ne 0 ]] ; then
        brew install $package
    fi
done

brew cleanup

#------------------------------------------
# 3. Get casks
#------------------------------------------

casks=()
# data science
casks+=("mactex" "rstudio" "xquartz")
# dev
casks+=("dotnet" "visual-studio")
# vm
casks+=("vagrant" "vagrant-manager" "virtualbox")
# misc
casks+=("caffeine" "postman")
# current
mycasks=($(brew cask list))
diff=(`echo ${casks[@]} ${mycasks[@]} | tr ' ' '\n' | sort | uniq -u`)

for cask in $diff ; do
    echo "Installing: " $cask
    brew cask install $cask
done

brew cask cleanup

#------------------------------------------
# 4. Cleanup
#------------------------------------------

brew doctor && brew cask doctor