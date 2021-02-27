#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
  rsync --exclude ".git/" \
        --exclude "bootstrap.sh" \
        --exclude "README.md" \
        --exclude "LICENSE-MIT.txt" \
        -avh --no-perms . ~;
  source ~/.bashrc;
}

function installPackages() {
  sudo apt install snap;
  sudo snap install chromium;
  sudo snap install inkscape;
  sudo snap install code --classic;
  sudo snap install android-studio --classic;
  
  # docker debian
  sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common;
  curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -;
  sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable";
   sudo apt-get update;
   sudo apt-get install docker-ce docker-ce-cli containerd.io;
   sudo groupadd docker;
   sudo usermod -aG docker $USER;
   
   # nvm node version manager
   curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
}


if [ "$1" == "--force" -o "$1" == "-f" ]; then
  doIt;
else
  read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
  echo "";
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    doIt;
  fi;
fi;

# cp /home/$username/.config/user-dirs.dirs

unset doIt;
