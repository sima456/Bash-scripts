#!/bin/bash
# updates every package manager

if command -v snap &>/dev/null; then
    sudo snap refresh
fi

if command -v apt &>/dev/null; then
    sudo apt update
    sudo apt upgrade
fi

if command -v flatpak &>/dev/null; then
    flatpak update
fi

if command -v pacman &>/dev/null; then
    sudo pacman -Syu
fi

if command -v yay &>/dev/null; then
    sudo yay -Syu
fi
