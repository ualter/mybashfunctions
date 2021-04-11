#!/bin/bash
AWSEE_SCRIPT="$(python -c 'import os, sys; print(os.path.dirname(sys.executable))')/awsee"
chmod +x $AWSEE_SCRIPT
echo "alias awsee='source awsee'" >> ~/.bashrc
alias awsee='source awsee'
echo  "------------" 
echo  "AWSee Ready!"
echo  "------------"
echo  "Try: awsee -u  or awsee -h"
echo  ""
