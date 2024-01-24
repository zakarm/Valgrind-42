# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    script.sh                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: zmrabet <marvin@42.fr>                     +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/03/21 01:29:49 by zmrabet           #+#    #+#              #
#    Updated: 2023/03/21 01:30:11 by zmrabet          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

GREEN='\033[1;32m'
RED='\033[1;31m'
NC='\033[0m'

print_success() {
    echo -e "$GREEN$1 √$NC"
}

print_error() {
    echo -e "$RED$1 X$NC"
}

print_info() {
    echo -e "$GREEN$1$NC"
}

print_info "42 @zmrabet"

# Check and create symbolic link for goinfre directory
if [ ! -e ~/goinfre ]; then
    ln -s /goinfre/$USER $HOME/goinfre > /dev/null 2>&1
    print_success "Symbolic link created for goinfre directory"
fi

# Add homebrew to PATH if not already present
if ! echo $PATH | grep -q "homebrew"; then
    echo "PATH=$HOME/goinfre/homebrew/bin:$PATH" >> ~/.zshrc
    print_success "Added homebrew to PATH"
fi

# Check and install homebrew if not present
if [ ! -e ~/goinfre/homebrew ]; then
    print_info "Installing Homebrew..."
    mkdir ~/goinfre/homebrew > /dev/null 2>&1
    curl --silent -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/goinfre/homebrew > /dev/null 2>&1
    [ $? -eq 0 ] && print_success "Homebrew installed successfully" || print_error "Failed to install Homebrew"
fi

# Update PATH
export PATH="$HOME/goinfre/homebrew/bin:$PATH"

# Install Valgrind using homebrew
print_info "Installing Valgrind !"
print_info "......................"

brew tap LouisBrunner/valgrind > /dev/null 2>&1

# Modify valgrind.rb for macOS 10.14.6
MAC=$(sw_vers | awk 'NR==2{print $2}')
if [ $MAC == "10.14.6" ]; then
    FILE="/goinfre/$USER/homebrew/Library/Taps/louisbrunner/homebrew-valgrind/valgrind.rb"
    sed -i '.bak' '/libtool/d' $FILE
fi

# Install valgrind
HOMEBREW_NO_AUTO_UPDATE=1 brew install --HEAD LouisBrunner/valgrind/valgrind
[ $? -eq 0 ] && print_success "Valgrind installed successfully" || print_error "Failed to install Valgrind"

# Restart shell
exec zsh

