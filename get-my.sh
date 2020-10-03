git clone -b rel https://github.com/ualter/mybashfunctions.git ~/.myfunctions
echo "source ~/.myfunctions/.myfunctions.sh" >> ~/.bashrc
echo "source ~/.myfunctions/.myfunctions.sh" >> ~/.zshrc
sleep 3
source ~/.zshrc
sleep 1
source ~/.bashrc
myf
echo ""
echo "Installed!"
echo ""
