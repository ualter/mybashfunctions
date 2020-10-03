#!/bin/bash

rm -rf ~/.myfunctions/
git clone -b rel https://github.com/ualter/mybashfunctions.git ~/.myfunctions
echo "source ~/.myfunctions/.myfunctions.sh" >> ~/.bashrc
echo "source ~/.myfunctions/.myfunctions.sh" >> ~/.zshrc
source ~/.bashrc
sleep 2
clear
echo ""
echo "----------------------"
printf "\033[0;93mInstalled!\n"
printf "\033[0;32mRun \033[0;94mmyf\033[0;32m to access help\033[0m\n"
echo "----------------------"
echo ""

