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

printf $GREEN"BY$RED @zmrabet $NC\n"

ls ~/goinfre > /dev/null 2>&1
if [ $? -ne 0 ]
then
	ln -s /goinfre/$USER $HOME/goinfre > /dev/null 2>&1
fi

echo $PATH | grep "homebrew" > /dev/null
if [ $? -ne 0 ]
then
echo "PATH=$HOME/goinfre/homebrew/bin:$PATH" >> ~/.zshrc
fi

ls ~/goinfre/homebrew &> /dev/null
if [ $? -ne 0 ]
then
	printf "$GREEN instaling Brew ... $NC "
	mkdir ~/goinfre/homebrew > /dev/null 2>&1
	curl --silent -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/goinfre/homebrew > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		printf " ----> X"
	else
		printf "$GREEN ----> √ $NC\n"
	fi		
fi
export PATH="$HOME/goinfre/homebrew/bin:$PATH"
printf "$GREEN instaling Valgrind ... \n$NC""might take a while $NC \n"
brew tap LouisBrunner/valgrind > /dev/null 2>&1

MAC=`sw_vers | awk 'NR==2{print $2}'`
if [ $MAC == "10.14.6" ]
then
FILE="/goinfre/$USER/homebrew/Library/Taps/louisbrunner/homebrew-valgrind/valgrind.rb"
sed -i '.bak' '/libtool/d' $FILE
fi
HOMEBREW_NO_AUTO_UPDATE=1 brew install --HEAD LouisBrunner/valgrind/valgrind
if [ $? -ne 0 ]
then
	printf "ERROR"
else
	printf "$GREEN valgrind installed successfully √$NC\n"
fi
exec zsh
