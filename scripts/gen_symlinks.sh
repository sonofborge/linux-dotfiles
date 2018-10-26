#!/bin/bash

set -euo pipefail


#
# Prompt user to remove all that config backup bullshit.
#
cleanup_aisle_five() {
  echo "    Want to remove your backups now?"
  read -p "        Enter [y/n]: " opt

  if [[ "y" == $opt ]]; then
    rm -rf ~/config_bkup
  else
    printf "\n"
    echo "    Cool beans. You're all set. \o/"
  fi
}


#
# Create ~/config_bkup dir if it doesn't already exist, 'cause we may need that
# shit.
#
create_config_bkup() {
  if [ ! -d ~/config_bkup ]; then
    mkdir ~/config_bkup
  fi
}


#
# Lastly, do the mothafuckin' thing!
#
ftw() {
  ln -s ~/code/linux-dotfiles/$1 ~/$1
  echo "    \"~/$1\" symlink created!"
}


#
# Second, actually backup, destroy, or ignore that mothafucka and let user know
# what the fuck they just did.
#
cross_your_tease() {
  if [[ "i" == $1 ]]; then
    echo "    Ignoring. Proceed ..."
  elif [[ "b" == $1 ]]; then
    create_config_bkup
    mv ~/$2 ~/config_bkup
    echo "    backup created in \"~/config_bkup/$2\""
  elif [[ "d" == $1 ]]; then
    rm ~/$2
    echo "    \"~/$2\" was destroyed."
  else
    echo "    Fuck you, n00b.  Doing nothing about \"~/$2\""
  fi
}


#
# First, life is about options. Check if user wants to backup, destroy or ignore
# that mothafucka.
#
dot_your_eyes() {
  printf "\n"

  if [[ -f ~/$1 || -d ~/$1 || -L ~/$1 ]]; then
    echo "    \"~/$1\" already exists! Backup (b), Destroy (d), or Ignore (i)?"
    read -p "        Enter [b/d/i] : " opt
    printf "\n"
    cross_your_tease $opt $1
    ftw $1
  else
    ftw $1
  fi
}


#
# Start the mothafuckin' magic ...
#
start() {
  dot_your_eyes .atom/styles.less
  dot_your_eyes .bash_aliases
  dot_your_eyes .bashrc
  dot_your_eyes .gitcompletion
  dot_your_eyes .gitconfig
  dot_your_eyes .gitignore
  dot_your_eyes .gitprompt
  dot_your_eyes .vim
  dot_your_eyes .vimrc

  printf "\n"

  cleanup_aisle_five
}

start
