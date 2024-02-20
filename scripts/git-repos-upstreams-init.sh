#!/bin/sh
#
# Clone upstream repos later used by home-manager

mkdir -p ~/GIT_REPOS/Upstreams
cd ~/GIT_REPOS/Upstreams
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git fast-syntax-highlighting 
git clone https://github.com/NvChad/NvChad nvchad
git clone https://github.com/ohmyzsh/ohmyzsh.git oh-my-zsh
