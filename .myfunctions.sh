#!/bin/bash

Reset='\033[0m'
Black='\033[0;30m' 
Red='\033[0;31m'   
Green='\033[0;32m' 
Yellow='\033[0;33m'
Blue='\033[0;34m'  
Purple='\033[0;35m'
Cyan='\033[0;36m'  
White='\033[0;37m' 
# Intensity
IBlack='\033[0;90m' 
IRed='\033[0;91m'   
IGreen='\033[0;92m' 
IYellow='\033[0;93m'
IBlue='\033[0;94m'  
IPurple='\033[0;95m'
ICyan='\033[0;96m'  
IWhite='\033[0;97m' 

#################################################################################
#
#   ____ _____ _   _ _____ ____  ___ ____ 
#  / ___| ____| \ | | ____|  _ \|_ _/ ___|
# | |  _|  _| |  \| |  _| | |_) || | |    
# | |_| | |___| |\  | |___|  _ < | | |___ 
#  \____|_____|_| \_|_____|_| \_\___\____|
#                                         
#
#################################################################################
# MINIKUBE
alias m='minikube $1 $2 $3 $4 $5 $6 $7'
# KUBERNETES
alias k='kubectl $1 $2 $3 $4 $5 $6 $7'
# DOCKER
alias d='docker $1 $2 $3 $4 $5 $6 $7'
# GIT
alias gpush='git add -A && git commit -m "." && git push'
# GENERIC
alias hg='history | grep'


myf() {
    clear
    echo " 😏🔨"
    echo "🔹${Cyan}=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-${Reset}🔹"
    echo " 📌🐳 ${IBlue}DOCKER${Reset}"
    echo "      docls............: ${Cyan}List Dockers:${Reset} docls [CONTAINER NAME]"                                                 | GREP_COLOR='01;32' egrep -i --color=always "docls"
    echo "      docexe...........: ${Cyan}Execute bash or sh in a docker container:${Reset} docexe {CONTAINER NAME} "                   | GREP_COLOR='01;32' egrep -i --color=always "docexe"
    echo "      docrm............: ${Cyan}Remove/Delete a Docker Container Instance:${Reset} docrm {CONTAINER NAME} "                   | GREP_COLOR='01;32' egrep -i --color=always "docrm"
    echo "      docip............: ${Cyan}Container IP Address:${Reset} docip [CONTAINER NAME]"                                         | GREP_COLOR='01;32' egrep -i --color=always "docip"
    echo "      docports.........: ${Cyan}Container Ports Bindings:${Reset} docports [CONTAINER NAME]"                                  | GREP_COLOR='01;32' egrep -i --color=always "docports"
    echo " "                  
    echo " 📌🎆 ${IBlue}KUBERNETES${Reset}"
    echo "      k8ns.............: ${Cyan}Change the namespace of kubectl context:${Reset} k8ns {NAMESPACE} "                           | GREP_COLOR='01;32' egrep -i --color=always "k8ns"
    echo " "                  
    echo " 📌🎎 ${IBlue}ALIAS${Reset}"
    echo "      minikube.........: m [arguments] " | GREP_COLOR='01;32' egrep -i --color=always "minikube"
    echo "      kubectl..........: k [arguments] " | GREP_COLOR='01;32' egrep -i --color=always "kubectl"
    echo "      docker...........: d [arguments] " | GREP_COLOR='01;32' egrep -i --color=always "docker"
    echo "      history..........: hg [string] "   | GREP_COLOR='01;32' egrep -i --color=always "history"
    echo "🔹${Cyan}=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-${Reset}🔹"
    echo ""
}                  


#################################################################################
#
#  _  ___   _ ____  _____ ____  _   _ _____ _____ _____ ____  
# | |/ / | | | __ )| ____|  _ \| \ | | ____|_   _| ____/ ___| 
# | ' /| | | |  _ \|  _| | |_) |  \| |  _|   | | |  _| \___ \ 
# | . \| |_| | |_) | |___|  _ <| |\  | |___  | | | |___ ___) |
# |_|\_\\___/|____/|_____|_| \_\_| \_|_____| |_| |_____|____/ 
#                                                             
#
#################################################################################
#################################################################################
# Change Namespace
#################################################################################
k8ns()  {
    echo ""
    echo "${Green}Running... Change kubectl default namespace${Reset}"
    if [ "$1" ]; then
       kubectl config set-context --current --namespace=$1
       echo "Changed the default namespace to $1" | GREP_COLOR='01;32' egrep -i --color=always "$1"
       kubectl config get-contexts
    else
       echo "${IRed}Missed argument, the namespace!${Reset}"
    fi
    echo ""
}

#################################################################################
#  ____   ___   ____ _  _______ ____  ____  
# |  _ \ / _ \ / ___| |/ / ____|  _ \/ ___| 
# | | | | | | | |   | ' /|  _| | |_) \___ \ 
# | |_| | |_| | |___| . \| |___|  _ < ___) |
# |____/ \___/ \____|_|\_\_____|_| \_\____/ 
#
#################################################################################

showHeader=1

listDocCmd() {
    index=1
    docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | while read -r line ; do
        echo " [$index] $line" | GREP_COLOR='01;33' egrep -i --color=always "\[$index\]|$1" 
        index=$(( $index + 1 ))
    done
}

getDockerIdOfLine() {
    index=1
    if [ "$2" ]; then
       docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | while read -r line ; do
           if (( $index == $2 )); then
               dockerId="$(echo $line | awk 'FNR == 1 {print $1}')"
               echo $dockerId
               return
           fi
           index=$(( $index + 1 ))
       done 
    else
       docker ps -a --format "{{.ID}} {{.Image}} {{.Names}}" | while read -r line ; do
           if (( $index == $1 )); then
               dockerId="$(echo $line | awk 'FNR == 1 {print $1}')"
               echo $dockerId
               return
           fi
           index=$(( $index + 1 ))
       done   
    fi
}
getDockerNameOfLine() {
    index=1
    if [ "$2" ]; then
       docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | while read -r line ; do
           if (( $index == $2 )); then
               dockerName="$(echo $line | awk 'FNR == 1 {print $3}')"
               echo $dockerName
               return
           fi
           index=$(( $index + 1 ))
       done 
    else
       docker ps -a --format "{{.ID}} {{.Image}} {{.Names}}" | while read -r line ; do
           if (( $index == $1 )); then
               dockerName="$(echo $line | awk 'FNR == 1 {print $3}')"
               echo $dockerName
               return
           fi
           index=$(( $index + 1 ))
       done
    fi   
}

showPickDockerLine() {
    lines=$(docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | wc -l)
    echo " +-------------------------------------------------------------------------------+"
    if [ "$1" ]; then
         echo " | *** More than one was found with $1 on its name" | GREP_COLOR='01;32' egrep -i --color=always "$1"
    fi     
    echo " | *** Please, pick out a line?"
    echo " | *** Between 1 to $(($lines))" | GREP_COLOR='01;32' egrep -i --color=always "1|$(($lines))|ENTER"
    echo " +-------------------------------------------------------------------------------+"
    echo " "
    listDocCmd $1 
}

#################################################################################
# List Dockers
#################################################################################
# Filter by name: lsdoc teachstore
docls() {
    clear
    echo ""
    echo "${Green} 🚀 Running... List Dockers $1${Reset}"
    echo ""
    if [ "$1" ]; then
        lines=$(docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | wc -l)
        if (( $lines > 1 )); then
           showPickDockerLine $1
           read var
           if [ -z "$var" ]; then
               return
           fi
           while true; do
                if (( $var > $lines )) || (( $var <= 0 )); then
                    echo " "
                    echo " $var --> Invalid line, please try again...  or  <ENTER> Exit" | GREP_COLOR='01;32' egrep -i --color=always "$var|ENTER"
                    echo " "
                    listDocCmd $1
                    echo " "
                    read var
                    if [ -z "$var" ]; then
                        return    
                    fi
                else 
                    break;   
                fi
           done
           dockerId=$(getDockerIdOfLine $1 $var)
           dockerName=$(getDockerNameOfLine $1 $var)
        else 
           # That's easy just one
           dockerId=$(getDockerIdOfLine $1 1)
           dockerName=$(getDockerNameOfLine $1 1)   
        fi
        echo " "
        echo " 🐳 Docker.............: ${IYellow}$dockerId${Reset}- $dockerName" | GREP_COLOR='01;32' egrep -i --color=always "$dockerName"
        echo " "
        echo $dockerId | xsel --clipboard
        echo ""
    else 
        docker ps
    fi    
}

#################################################################################
# Execute bash/sh iterativo on Docker Container Instance
#################################################################################
# Filter by name: exedoc ualter
docexe() {
    clear
    echo ""
    echo "${Green} 🚀 Running... Execute bash/sh iterativo on Docker Container Instance${Reset}"
    echo ""
    lines=$(docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | wc -l)
    if (( $lines > 1 )); then
        showPickDockerLine $1
        echo "${Green} ----------------------------------------------------------------------------"
        printf " <ENTER to Exit> ${IBlue}Line number: ${Reset}"
        read var
        if [ -z "$var" ]; then
            return
        fi
        while true; do
            if (( $var > $lines )) || (( $var <= 0 )); then
                echo " "
                echo " $var --> Invalid line, please try again...  or  <ENTER> Exit" | GREP_COLOR='01;32' egrep -i --color=always "$var|ENTER"
                echo " "
                listDocCmd $1
                echo " "
                read var
                if [ -z "$var" ]; then
                    return    
                fi
            else 
                break;   
            fi
        done
        dockerId=$(getDockerIdOfLine $1 $var)
        dockerName=$(getDockerNameOfLine $1 $var)
    else 
        # That's easy just one
        dockerId=$(getDockerIdOfLine $1 1)
        dockerName=$(getDockerNameOfLine $1 1)   
    fi
    echo " "
    echo "  🐳 Target Docker........: ${IYellow}$dockerId${Reset} - $dockerName" | GREP_COLOR='01;32' egrep -i --color=always "$dockerName"
    echo " "
    echo " +-------------------------------+"
    echo " |  Which command to execute?    |"
    echo " |  (1) sh                       |" | GREP_COLOR='01;32' egrep -i --color=always "1"
    echo " |  (2) bash                     |" | GREP_COLOR='01;32' egrep -i --color=always "2"
    echo " |  <ENTER> Exit                 |" | GREP_COLOR='01;32' egrep -i --color=always "ENTER"
    echo " +-------------------------------+"
    echo " "
    read var
    if [ "$var" = 1 ]; then
        docker exec -it $dockerId sh
    elif [ "$var" = 2 ]; then    
        docker exec -it $dockerId bash
    fi
}

#################################################################################
# Remove/Delete a Docker Container Instance
#################################################################################
# Filter by name: rmdoc ualter
docrm() {
    clear
    echo ""
    echo "${Green} 🚀 Running... Remove/Delete a Docker Container Instance${Reset}"
    echo ""
    lines=$(docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | wc -l) 
    if (( $lines > 1 )); then
        showPickDockerLine $1
        echo "${Green} ----------------------------------------------------------------------------"
        printf " <ENTER to Exit> ${IBlue}Line number: ${Reset}"
        read var
        if [ -z "$var" ]; then
            return
        fi
        while true; do
            if (( $var > $lines )) || (( $var <= 0 )); then
                echo " "
                echo " $var --> Invalid line, please try again...  or  <ENTER> Exit" | GREP_COLOR='01;32' egrep -i --color=always "$var|ENTER"
                echo " "
                #listDocCmd $1
                echo " "
                read var
                if [ -z "$var" ]; then
                    return    
                fi
            else 
                break;   
            fi
        done
        dockerId=$(getDockerIdOfLine $1 $var)
        dockerName=$(getDockerNameOfLine $1 $var)
    else 
        # That's easy just one
        dockerId=$(getDockerIdOfLine $1 1)
        dockerName=$(getDockerNameOfLine $1 1)   
    fi
    echo " "
    echo "  🐳 Target Docker........: ${IYellow}$dockerId${Reset} - $dockerName" | GREP_COLOR='01;32' egrep -i --color=always "$dockerName"
    echo " "
    echo " +---------------------------------+"
    echo " |  Are you sure to  DELETE  it?   |" | GREP_COLOR='101;93;1;5' egrep -i --color=always " DELETE "
    echo " |  (1) Yes                        |" | GREP_COLOR='01;32' egrep -i --color=always "1"
    echo " |  (2) No                         |" | GREP_COLOR='01;32' egrep -i --color=always "2"
    echo " |  <ENTER> No/Exit                |" | GREP_COLOR='01;32' egrep -i --color=always "ENTER"
    echo " +---------------------------------+"
    echo " "
    read var
    if [ "$var" = 1 ]; then
        docker rm -f $dockerId
    fi
}

_functionInspect=""
_docInspect=""  
#################################################################################
# Docs IP Address
#################################################################################
# Filter by name: docip
docip() {
    if [ "$showHeader" = 1 ]; then
         clear
         echo ""
         echo "${Green} 🚀 Running... IP Address Container $1${Reset}"
    fi    
    _functionInspect="docip"
    _docInspect $1
    showHeader=0
    if [ "$_docInspect" = "" ]; then
         docip $1
    else       
         _docInspect=""
    fi
}
#################################################################################
# Docs Ports
#################################################################################
# Filter by name: docip
docports() {
    if [ "$showHeader" = 1 ]; then
         clear
         echo ""
         echo "${Green} 🚀 Running... Ports of the Container $1${Reset}"
    fi    
    _functionInspect="docports"
    _docInspect $1
    showHeader=0
    if [ "$_docInspect" = "" ]; then
         docports $1
    else 
         _docInspect=""
    fi
}

_docInspect() {
    if [ "$1" ]; then
        lines=$(docker ps -a -f name=$1 --format "{{.ID}} {{.Image}} {{.Names}}" | wc -l)
    else     
        lines=$(docker ps -a --format "{{.ID}} {{.Image}} {{.Names}}" | wc -l)
    fi    
    if (( $lines > 1 )); then
       showPickDockerLine $1
       echo "${Green} ----------------------------------------------------------------------------"
       printf " <ENTER to Exit> ${IBlue}Line number: ${Reset}"
       read var
       if [ -z "$var" ]; then
           _docInspect="end"
           return
       fi
       while true; do
            if (( $var > $lines )) || (( $var <= 0 )); then
                echo " "
                echo " $var --> Invalid line, please try again...  or  <ENTER> Exit" | GREP_COLOR='01;32' egrep -i --color=always "$var|ENTER"
                echo " "
                #listDocCmd $1
                echo " "
                read var
                if [ -z "$var" ]; then
                    echo ""
                    return    
                fi
            else 
                break;   
            fi
       done
       dockerId=$(getDockerIdOfLine $1 $var)
       dockerName=$(getDockerNameOfLine $1 $var)
    else 
       # That's easy just one
       dockerId=$(getDockerIdOfLine $1 1)
       dockerName=$(getDockerNameOfLine $1 1)   
    fi
    echo " "
    echo " 🐳 Docker.............: ${IYellow}$dockerId${Reset} - $dockerName" | GREP_COLOR='01;32' egrep -i --color=always "$dockerName"
    if [ "$_functionInspect" = "docip" ]; then
       result=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $dockerId)
       printf "${IBlue} 🔵🔴🔵 IPAddress..........:${IGreen} $result${Reset}  ${Cyan}<ENTER>${Reset}"
       read var
    elif [ "$_functionInspect" = "docports" ]; then
       result=$( docker ps -f id=$dockerId --format '{{.Ports}}')
       printf "${IBlue} 🔵🔴🔵 Ports..........:${IGreen} $result${Reset}  ${Cyan}<ENTER>${Reset}"
       read var
    fi
    echo " "
}
