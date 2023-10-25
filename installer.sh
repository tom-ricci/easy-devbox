#!/bin/bash

# so, we need to:
# 1. ask if we want to install nix - if no, echo a link to the installer guide
# 2. ask if we want to install direnv - if no, echo a link to the direnv guide
# 3. install nix and/or direnv
# 4. install devenv

echo "__| |_____________________________________________________________________________________________| |__";
echo "__   _____________________________________________________________________________________________   __";
echo "  | |                                                                                             | |  ";
echo "  | |                                                                                             | |  ";
echo "  | |                                                                                             | |  ";
echo "  | |          ___           ___           ___           ___           ___           ___          | |  ";
echo "  | |         /\  \         /\  \         /\__\         /\  \         /\__\         /\__\         | |  ";
echo "  | |        /::\  \       /::\  \       /:/  /        /::\  \       /::|  |       /:/  /         | |  ";
echo "  | |       /:/\:\  \     /:/\:\  \     /:/  /        /:/\:\  \     /:|:|  |      /:/  /          | |  ";
echo "  | |      /:/  \:\__\   /::\~\:\  \   /:/__/  ___   /::\~\:\  \   /:/|:|  |__   /:/__/  ___      | |  ";
echo "  | |     /:/__/ \:|__| /:/\:\ \:\__\  |:|  | /\__\ /:/\:\ \:\__\ /:/ |:| /\__\  |:|  | /\__\     | |  ";
echo "  | |     \:\  \ /:/  / \:\~\:\ \/__/  |:|  |/:/  / \:\~\:\ \/__/ \/__|:|/:/  /  |:|  |/:/  /     | |  ";
echo "  | |      \:\  /:/  /   \:\ \:\__\    |:|__/:/  /   \:\ \:\__\       |:/:/  /   |:|__/:/  /      | |  ";
echo "  | |       \:\/:/  /     \:\ \/__/     \::::/__/     \:\ \/__/       |::/  /     \::::/__/       | |  ";
echo "  | |        \::/__/       \:\__\        ~~~~          \:\__\         /:/  /       ~~~~           | |  ";
echo "  | |         ~~            \/__/                       \/__/         \/__/                       | |  ";
echo "  | |                                                                                             | |  ";
echo "  | |                                                                                             | |  ";
echo "__| |_____________________________________________________________________________________________| |__";
echo "__   _____________________________________________________________________________________________   __";
echo "  | |                                                                                             | |  ";

sleep 1;

echo "Welcome to the devenv installer!";

sleep 1;

# if we aren't using bash, the shell might not support the commands we are going to ask of it, and we should exit if necessary.
DEVENV_SHELL=$(basename "$(readlink /proc/$$/exe)");
if [[ $DEVENV_SHELL != "bash" ]]; then
  echo -e "It seems like this shell isn't bash. This script was designed with bash in mind; are you sure you want to continue? (y/n)";
  read -r DEVENV_CONTINUE;
  DEVENV_CONTINUE=${DEVENV_CONTINUE^^}
  if [[ $DEVENV_CONTINUE != "Y" ]]; then
    echo -e "Okay, aborting...";
    exit 1;
  fi
fi

# if we're still running, now we need to figure out what we have installed already
DEVENV_APT=$(command -v apt-get);
DEVENV_NIX=$(command -v nix);
DEVENV_DIRENV=$(command -v direnv);
DEVENV_BASHRC=$(grep -wq 'eval "$(direnv hook bash)"' "$HOME/.bashrc");

# if we don't have apt-get and need to install something, we won't be able to, and we should exit (although the user can choose not to for some reason)
if ! $DEVENV_APT &> /dev/null && ! $DEVENV_NIX &> /dev/null || ! $DEVENV_APT &> /dev/null && ! $DEVENV_DIRENV &> /dev/null ; then
  echo -e "It seems like apt-get isn't installed on this system. This script requires apt-get; are you sure you want to continue? (y/n)";
  read -r DEVENV_CONTINUE;
  DEVENV_CONTINUE=${DEVENV_CONTINUE^^}
  if [[ $DEVENV_CONTINUE != "Y" ]]; then
    echo -e "Okay, aborting...";
    exit 1;
  fi
fi

# Install nix
if ! $DEVENV_NIX &> /dev/null; then
  echo "It seems like you don't have Nix, installing...";
  sh <(curl -L https://nixos.org/nix/install) --daemon
fi

# Install direnv
if ! $DEVENV_DIRENV &> /dev/null; then
  echo "It seems like you don't have direnv, installing...";
  sudo apt-get install direnv
fi
if ! $DEVENV_BASHRC; then
  echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
fi

# Install devenv commands
touch