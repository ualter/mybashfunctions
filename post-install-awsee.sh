#!/bin/bash
AWSEE_SCRIPT="$(python -c 'import os, sys; print(os.path.dirname(sys.executable))')/awsee"
chmod +x $AWSEE_SCRIPT
echo "alias awsee='source awsee'" >> ~/.bashrc 
