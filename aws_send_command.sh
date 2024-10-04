# function syntax() {
# 	echo ""
# 	echo ""
# 	printf "\033[0;32m"
# 	echo "------------------------------------------------------------------------"
# 	printf "\033[0m"
# 	echo "  USAGE"
# 	echo "  Two options:"
# 	printf "\033[0;32m"
# 	echo "------------------------------------------------------------------------"
# 	printf "\033[0;32m"
# 	echo "    1) Inform the command directly, examples:"
# 	printf "\033[0;94m"
# 	echo "       $ ./aws_send_command.sh  ls"
# 	echo "       $ ./aws_send_command.sh  ifconfig"
# 	echo "       $ ./aws_send_command.sh  pwd"
# 	printf "\033[0;32m"
# 	echo "       ### Double quote commands with spaces on it"
# 	printf "\033[0;94m"
# 	echo "       $ ./aws_send_command.sh  \"aws s3 ls\""
# 	echo "       $ ./aws_send_command.sh  \"ls home\""
# 	echo "       $ ./aws_send_command.sh  \"ls ~/\""
# 	printf "\033[0;32m"
# 	echo "       ### Using multiple commands separated by comma"
# 	printf "\033[0;94m"
# 	echo "       $ ./aws_send_command.sh \"ls /home,pwd\""
# 	echo "       $ ./aws_send_command.sh \"pwd,ls /home\""
# 	echo ""
# 	printf "\033[0;32m"
# 	echo "    OR "
# 	echo ""
# 	printf "\033[0;32m"
# 	echo "    2) Inform the json file containing the commands, example:"
# 	printf "\033[0;94m"
# 	echo "       $ ./aws_send_command.sh  my-commands.json"
# 	echo ""     
# 	printf "\033[0;32m"
# 	echo "         Example of a json file:"
# 	printf "\033[0;94m"
# 	echo "         {"
#     echo "           \"Parameters\": {"
#     echo "             \"commands\": ["
#     echo "                 \"#!/bin/bash\","
#     echo "                 \"ls /home\","
#     echo "                 \"ifconfig\","
#     echo "                 \"pwd\","
#     echo "             ]"
#     echo "           }"
#     echo "         }"
#     echo ""
#     printf "\033[0m"
# }
keyInstance="NOT DEFINED"
if [ -f "aws_send_command_env.json" ]; then
   ## aws_send_command_env.json format:
   ## keyInstance=i-0992307963325b917
   source "aws_send_command_env.json"
else
   # File with the manage instance Id not found	
   keyInstance=i-00ac3d9d1b8d05add	
fi

if [ $# -eq 0 ]; then
   syntax
   exit 1
fi

echo ""
echo ""
printf "\033[0;32m"
echo "MANAGE INSTANCE BEING USED:"
echo "----------------------------------------------------"
printf "\033[0;94m"
echo "$keyInstance"
echo ""

useJsonFile=False
jsonFile=""
for var in "$@"
do
	if [[ $var == *".json"* ]]; then
          useJsonFile=True
          jsonFile=$var
    fi
done

if [ $useJsonFile == True ]; then
	if [ -f "$jsonFile" ]; then
		commandIdResult=$(aws ssm send-command --document-name "AWS-RunShellScript" --targets "Key=InstanceIds,Values=$keyInstance" --cli-input-json file://$jsonFile --query "Command.CommandId")
	else
		echo ""
		printf "\033[0;32m"
		echo "-----------------------------------------------------------------------------"
		printf "\033[0;91m"
		echo "JSON File \"$jsonFile\" was not found!"
		printf "\033[0;32m"
		echo "-----------------------------------------------------------------------------"
		echo ""
		exit 1
	fi 
else
	if [ -z "$1" ]; then
	    syntax
	    exit 1
	fi

    if [[ $var == *","* ]]; then    
	    IFS=',' read -r -a array <<< "$1"
	    for element in "${array[@]}"
	    do
	    	if [ -z "$commands" ]; then
	    		commands="'$element'"
	    	else
	    		commands="$commands,'$element'"
	    	fi
	    done
	else 
		commands="'$1'"
	fi    

    commandIdResult=$(aws ssm send-command --document-name "AWS-RunShellScript" --parameters "commands=[$commands]"  --targets "Key=instanceids,Values=$keyInstance" --comment "Command Executed" --query "Command.CommandId")
fi


commandIdResult=$(echo $commandIdResult | sed s/\"//g)
echo ""
printf "\033[0;32m"
echo "COMMAND ID:"
echo "----------------------------------------------------"
printf "\033[0;94m"
echo "$commandIdResult"

# Time
value=$(aws ssm get-command-invocation --command-id $commandIdResult --instance-id  $keyInstance)
standarOutput=$(aws ssm get-command-invocation --command-id $commandIdResult --instance-id  $keyInstance --query "StandardOutputContent")
standardError=$(aws ssm get-command-invocation --command-id $commandIdResult --instance-id  $keyInstance --query "StandardErrorContent")

if [ "$standardError" != "" ]; then
	 standardError=$(echo $standardError | sed s/\"//g)
	 echo ""
	 printf "\033[0;91m"
     echo "ERROR Output"
     echo "----------------------------------------------------"
     printf "\033[0;94m"
	 echo $standardError | sed 's/\\n/\
/g'
fi


standarOutput=$(echo $standarOutput | sed s/\"//g)
echo ""
printf "\033[0;32m"
echo "STANDARD Output"
echo "----------------------------------------------------"
printf "\033[0;94m"
echo $standarOutput | sed 's/\\n/\
/g'

