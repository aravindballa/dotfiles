#!/usr/bin/env bash

# ~/.macos — https://mths.be/macos
# Modified by Aravind Balla

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Ask for the administrator password upfront
sudo -v

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "Hello $(whoami)! Let's get you set up."

# Show the ~/Library folder
chflags nohidden ~/Library

# Show the /Volumes folder
sudo chflags nohidden /Volumes

# Save to disk (not to iCloud) by default
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Automatically quit printer app once the print jobs complete
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true

# Disable the “Are you sure you want to open this application?” dialog
defaults write com.apple.LaunchServices LSQuarantine -bool false

# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

echo "installing homebrew"
# install homebrew https://brew.sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

echo "brew installing stuff"
# hub: a github-specific version of git
# tree: really handy for listing out directories in text
# xz: Extract .xz files
# z: fuzzy match directories, cd in dir from anywhere
brew install hub tree fortune fzf z wget xz zsh zsh-completions bat git-lfs

echo "configuring git"
git config --global user.name "Aravind Balla"
git config --global user.email "bsaaravind@gmail.com"

echo "cloning dotfiles"
git clone https://github.com/aravindballa/dotfiles "${HOME}/dotfiles"
ln -s "${HOME}/dotfiles/.zshrc" "${HOME}/.zshrc"

echo "installing nvm and node"
curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
source ~/.zshrc
nvm --version
nvm install node
nvm use node

echo "installing a few global npm packages"
npm install --global serve fkill-cli 

brew install yarn --ignore-dependencies

echo "installing apps with brew cask"
brew cask install google-chrome firefox \
visual-studio-code dash \
kap obs zoomus hyper

echo "Generating an RSA token for GitHub"
ssh-keygen -t rsa -b 4096 -C "bsaaravind@gmail.com"
echo "Host *\n AddKeysToAgent yes\n UseKeychain yes\n IdentityFile ~/.ssh/id_rsa" | tee ~/.ssh/config
eval "$(ssh-agent -s)"
echo "run 'pbcopy < ~/.ssh/id_rsa.pub' and paste that into GitHub"

echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
